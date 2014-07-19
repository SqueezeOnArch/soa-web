#!/usr/bin/env luajit

-- Squeeze on Arch (SOA) Web Configuration and Control Interface
--
-- Copyright (C) 2014 Adrian Smith <triode1@btinternet.com>
--
-- This file is part of soa-web.
--
-- soa-web is licensed for non commercial use under the terms of the 
-- GNU General Public License as published by the Free Software Foundation, 
-- either version 3 of the License, or (at your option) any later version.
--
-- soa-web is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with soa-web. If not, see <http://www.gnu.org/licenses/>.

local turbo = require('turbo')
local io    = require('io')
local lfs   = require('lfs')
local ffi   = require('ffi')
ffi.cdef[[int fileno(void *)]]

-- globals accessed by required modules
log   = turbo.log
util  = {}
cfg   = {}

local NetworkConfig     = require('soa-web.NetworkConfig')
local SqueezeliteConfig = require('soa-web.SqueezeliteConfig')
local StorageConfig     = require('soa-web.StorageConfig')
local Update            = require('soa-web.Update')

local strings, language

------------------------------------------------------------------------------------------

-- configuration

-- release version id
local release = "0.1"

-- server port
local PORT = 8081

-- paths to our templates and static content
local path  = "."
local templ_path  = path .. '/templ/'
local static_path = path .. '/static/'

-- languages supported
local languages = { EN = true }

-- skin branding
local skin = {
	brand_name = "Squeeze on Arch",
	logo_small = "static/soa-logo-100x65.jpg",
	logo_small_alt = "Logo (small)",
	logo_small_width = "100",
	logo_small_height = "65",
	logo_large = "static/soa-logo-533x342.jpg",
	logo_large_alt = "Logo (large)",
	logo_large_width = "533",
	logo_large_height = "342",
}

------------------------------------------------------------------------------------------

-- utils
local debug      = arg[1] and arg[1] == '--debug'
local test_mode  = arg[1] and arg[1] == '--test'
local string_chk = arg[1] and arg[1] == '--strings' and arg[2]
local string_miss= arg[1] and arg[1] == '--missing' and arg[2]

-- execute a process and capture output using coroutines to reduce chance of blocking with streaming of output to sink
-- timeout after 5 seconds or 30 mins if passed a request which will normally handle closing itself
local CMD_TIMEOUT_NORMAL  = 5 * 1000
local CMD_TIMEOUT_PERSIST = 30 * 60 * 1000

function _process_cmd(cmd, sink, request)
	local fh = io.popen(cmd .. " 2>&1", "r")
	if fh == nil then
		return nil
	end

	local fileno = ffi.C.fileno(fh)
	local ioloop = turbo.ioloop.instance()
	local chunksize = sink and "*l" or 4096
	local timeout = request and CMD_TIMEOUT_PERSIST or CMD_TIMEOUT_NORMAL
	local reader, close, forceclose
	local chunks = {}

	local to = ioloop:add_timeout(turbo.util.gettimeofday() + timeout, function() forceclose() end)

	coroutine.yield(turbo.async.task(
		function(cb, arg)
			reader = function()
						 local chunk = fh:read(chunksize)
						 if sink then
							 sink(chunk)
						 end
						 if chunk == nil then
							 close()
						 else
							 chunks[#chunks + 1] = chunk
						 end
					 end
			close  = function()
						 ioloop:remove_handler(fileno)
						 ioloop:remove_timeout(to)
						 fh:close()
						 if request then
							 request.__stream_close = nil
						 end
						 cb(arg)
					 end
			forceclose = function()
							 -- popen waits for the process to finish, so kill it
							 log.debug("killing process: " .. cmd)
							 os.execute("pkill -f " .. '"' .. cmd .. '"')
							 close()
						 end
			if request then
				request.__stream_close = forceclose
			end
			turbo.ioloop.instance():add_handler(fileno, turbo.ioloop.READ, reader)
		end
	))

	if not sink then
		return table.concat(chunks)
	end
end

util.capture = function(cmd)
	log.debug("capture: " .. cmd)
	if test_mode then
		return "capture: " .. cmd
	end
	return _process_cmd(cmd)
end

util.execute = function(cmd)
	log.debug("execute: " .. cmd)
	if test_mode then
		return
	end
	_process_cmd(cmd)
end

util.stream = function(cmd, sink, request)
	log.debug("streaming cmd: " .. cmd)
	_process_cmd(cmd, sink, request)
end

if not debug and not test_mode then
	log.categories.debug   = false
	log.categories.success = false
end

-- cached param and strings table for footer
local footer_t = { release = release }

------------------------------------------------------------------------------------------

-- detect config

cfg.tmpdir = "/tmp"
cfg.update = Update.available()
cfg.storage = StorageConfig:available()

if cfg.update then
	local installed = Update.installed()
	cfg.squeezelite, cfg.squeezeserver = installed.squeezelite, installed.squeezeserver
else
	cfg.squeezelite, cfg.squeezeserver = true, true
end

local ip = io.popen("ip link")
if ip then
	for line in ip:lines() do
		local eth  = string.match(line, "%d: (e.-):")
		local wlan = string.match(line, "%d: (w.-):")
		if eth and cfg.wired == nil then
			cfg.wired = eth
		end
		if wlan and cfg.wireless == nil then
			cfg.wireless = wlan
		end
	end
	ip:close()
end

if test_mode then
	cfg.update, cfg.storage = true, true
	cfg.wired = cfg.wired or "test"
	cfg.wireless = cfg.wireless or "test"
end

------------------------------------------------------------------------------------------

-- strings
local stringsPrefix = "soa-web/Strings-"
local prefsFile     = os.getenv("HOME") .. "/.soa-web.lang"

function get_language()
	local file = io.open(prefsFile, "r")
	local lang
	if file then
		lang = file:read("*l")
		file:close()
	end
	if languages[lang] then
		return lang
	end
end

function set_language(lang)
	local file = io.open(prefsFile, "w")
	if file then
		file:write(lang .. "\n")
		file:close()
	end
end

function load_strings(lang)
	local path = package.path .. ";"
	for loc in string.gmatch(package.path, "(.-);") do
		local file = string.gsub(loc, "%?", stringsPrefix .. lang) do
			local f, err = loadfile(file)
			if f then
				setfenv(f, {})
				strings = f()
				break
			end
		end
	end

	-- add metamethods so categories fallback to base within same language
	for section, _ in pairs(strings) do
		if section ~= 'base' and section ~= 'languages' then
			setmetatable(strings[section], { __index = strings['base'] })
		end
	end

	setmetatable(strings['base'], { __index = skin })
	setmetatable(footer_t, { __index = strings['footer'] })

	if test_mode then
		-- log string misses, excluded params which start with p_
		local func = function(t, str) 
						 if not string.match(str, "^p_") then
							 log.debug("missing string [" .. language .. "]: " .. str)
						 end
					 end
		setmetatable(skin, { __index = func })
	end
end

-- utility to check strings, exit after dumping strings
if string_chk or string_miss then
	local lang = string_chk or string_miss
	load_strings('EN')
	local EN = strings
	load_strings(lang)
	for page, v in pairs(EN) do
		local header
		for s, en_text in pairs(v) do
			local str = (strings[page] or {})[s]
			if string_chk or (string_miss and not str) then
				if not header then print(page) header = true end
				print("  " .. s)
				print("     EN: " .. en_text)
				if string_chk then
					print("     " .. lang .. ": " .. (str or "**** MISSING ****"))
				end
			end
		end
	end
	os.exit()
end

language = get_language() or 'EN'

load_strings(language)

------------------------------------------------------------------------------------------

-- setup handlers
local templ = turbo.web.Mustache.TemplateHelper(templ_path)

local PageHandler = class("PageHandler", turbo.web.RequestHandler)

-- common actions
local service_actions = {
	--refresh does nothing - systemctl status is called in _response handler
	enable         = { "sudo systemctl enable %s" },
	disable        = { "sudo systemctl disable %s" },
	start          = { "sudo systemctl start %s" },
	stop           = { "sudo systemctl stop %s" },
	restart        = { "sudo systemctl restart %s" },
	enableAndStart = { "sudo systemctl enable %s", "sudo systemctl start %s" },
	disableAndStop = { "sudo systemctl disable %s", "sudo systemctl stop %s" },
}

function PageHandler:renderResult(template, t)
	local header_t = { context = t['context'], p_wired = cfg.wired, p_wireless = cfg.wireless, p_update = cfg.update,
					   p_squeezelite = cfg.squeezelite, p_squeezeserver = cfg.squeezeserver, p_storage = cfg.storage }
	setmetatable(header_t, { __index = strings['header'] })
	self:write( templ:render('header.html', header_t ) )
	self:write( templ:render(template, t) )
	self:write( templ:render('footer.html', footer_t) )
end

function PageHandler:serviceActions(service)
	for action, val in pairs(service_actions) do
		if self:get_argument(action, false) then
			for _, str in ipairs(val) do
				local cmd = string.format(str, service)
				log.debug("service action: " .. cmd)
				util.execute(cmd)
			end
		end
	end
end

local IndexHandler       = class("IndexHandler", PageHandler)
local SystemHandler      = class("SystemHandler", PageHandler)
local NetworkHandler     = class("NetworkHandler", PageHandler)
local SqueezeliteHandler = class("SqueezeliteHandler", PageHandler)
local SqueezeserverHandler = class("SqueezeserverHandler", PageHandler)
local StorageHandler     = class("StorageHandler", PageHandler)
local ShutdownHandler    = class("ShutdownHandler", PageHandler)
local UpdateHandler      = class("UpdateHandler", PageHandler)
local LogHandler         = class("LogHandler", turbo.web.RequestHandler)

------------------------------------------------------------------------------------------

local installProgressFile = cfg.tmpdir .. "/soa-install-progress"

-- index.html
function IndexHandler:get()
	local lang = self:get_argument('locale', false)
	if lang and languages[lang] then
		log.debug("set language: " .. lang)
		load_strings(lang)
		set_language(lang)
		language = lang
	end

	local t = { p_languages = {} }

	local l = t['p_languages']
	for k, _ in pairs(languages) do
		l[#l+1] = { lang = k, desc = strings['languages'][k], selected = (k == language and "selected" or "") }
	end

	local install = io.open(installProgressFile, "r")
	if install then
		t['p_prog'] = install:read()
		install:close()
	end

	setmetatable(t, { __index = strings['index'] })
	self:renderResult('index.html', t)
end

------------------------------------------------------------------------------------------

-- system.html
local info_files = {
	hostname       = '/etc/hostname',
}

local localefile  = '/etc/locale.conf'
local localesfile = '/usr/share/system-config-language/locale-list'
local zonefiles   = '/usr/share/zoneinfo/'

function _zones(dir)
	local attr = lfs.attributes(zonefiles .. (dir or ""))
	local t = {}
	if attr and attr.mode == "directory" then
		for file in lfs.dir(zonefiles .. (dir or "")) do
			if not (file == "." or file == ".." or file == "posix" or file == "right" or file == "posixrules" or
					string.match(file, "%.tab$")) then
				local path = dir and (dir .. "/" .. file) or file
				if lfs.attributes(zonefiles .. path).mode == "directory" then
					for _, v in ipairs(_zones(path)) do
						table.insert(t, v)
					end
				else
					table.insert(t, path)
				end
			end
		end
	end
	return t
end

function SystemHandler:_response()
	local t = {}
	
	for k, v in pairs(info_files) do
		local file = io.open(v, 'r')
		if file then
			t['p_' .. k] = file:read("*l") or ""
			file:close()
		else
			t['p_' .. k] = "."
		end
	end
	
	local zones = _zones()
	table.sort(zones)
	
	local info = util.capture("ls -l /etc/localtime")
	local zone = string.match(info, zonefiles .. "(.-)\n")
	
	t['p_zones'] = {}
	for _, v in ipairs(zones) do
		table.insert(t['p_zones'], { zone = v, selected = (v == zone and "selected" or "") })
	end
	
	local cur_locale
	local file = io.open(localefile, "r")
	if file then
		for line in file:lines() do
			if string.match(line, "LANG") then
				cur_locale = string.match(line, 'LANG="(.-)"')
			end
		end
		file:close()
	end
	t['p_locale'] = cur_locale
	
	t['p_locales'] = {}
	local file = io.open(localesfile, "r")
	if file then
		for line in file:lines() do
			local locale, desc = string.match(line, "^(.-)%s.-%s.-%s(.*)$")
			if locale and desc then
				table.insert(t['p_locales'], { loc = locale, selected = (locale == cur_locale and "selected" or ""), desc = desc })
			end
		end
		file:close()
	end

	setmetatable(t, { __index = strings['system'] })
	self:renderResult('system.html', t)
end

function SystemHandler:get()
	self:_response()
end

function SystemHandler:post()
	local tmpFile = cfg.tmpdir .. '/tmpfile.txt-luagui'

	local hostname = self:get_argument("hostname", false)
	if hostname then
		log.debug("setting hostname to " .. hostname)
		util.execute("sudo hostnamectl set-hostname " .. hostname)
	end
	
	local newzone = self:get_argument("timezone", false)
	if newzone then
		log.debug("setting timezone to " .. newzone)
		util.execute("sudo ln -sf /usr/share/zoneinfo/" .. newzone .. " /etc/localtime")
	end
	
	self:_response()
end

------------------------------------------------------------------------------------------

-- network.html
function NetworkHandler:_response(type, err)
	local int = (type == "wired" and cfg.wired or cfg.wireless)
	local is_wireless = (type ~= "wired")
	local config = NetworkConfig.get(int, is_wireless)
	local t = {}

	if err then
		t['p_error'] = err and (strings['network']["error_" .. err] or 'validation error - ' .. err)
	end

	t['p_iftype'] = type
	t['p_is_wlan'] = is_wireless
	t['p_onboot_checked'] = config.onboot and "checked" or ""
	t['p_dhcp_checked']   = config.dhcp and "checked" or nil
	t['p_ipv4'] =  strings['network']['none']
	t['p_state'] = strings['network']['none']

	local status = util.capture("ifconfig " .. int)
	for line in string.gmatch(status, "(.-)\n") do
		local state = string.match(line, "flags=%d+<(.-),")
		local ipv4 = string.match(line, "inet (.-) ")
		if state and state ~= "BROADCAST" then
			t['p_state'] = state
		end
		if ipv4 then
			t['p_ipv4'] = ipv4
		end
	end

	for _, v in ipairs(NetworkConfig.params(is_wireless)) do
		t["p_"..v] = config[v]
	end

	if is_wireless then
		local scan, status = NetworkConfig.scan_wifi()

		t['p_wpa_state'] = status['wpa_state'] or strings['network']['none']

		t['p_essids'] = {}
		local essids = {}
		for _, v in ipairs(scan) do
			table.insert(t['p_essids'], { id = v.ssid, selected = (v.ssid == config.essid and "selected" or "") })
			essids[v.ssid] = true
		end
		-- put previous selection on top of list if not already there
		if not essids[config.essid] and config.essid ~= "XXXXXXXX" then
			table.insert(t['p_essids'], 1, { id = config.essid, selected = "selected" })
		end
		-- add option to add private network
		table.insert(t['p_essids'], { id = strings['network']['add_private'] })

		t['p_countries'] = { { id = "", desc = "" } }
		for _, v in ipairs(NetworkConfig.regions()) do
			table.insert(t['p_countries'], { id = v, selected = (v == config.country and "selected" or ""), 
											 desc = strings['network'][v] or v})
		end
	end

	setmetatable(t, { __index = strings['network'] })
	self:renderResult('network.html', t)
end

function NetworkHandler:get(type)
	self:_response(type)
end

function NetworkHandler:post(type)
	local int = (type == "wired" and cfg.wired or cfg.wireless)
	local is_wireless = (type ~= "wired")

	if self:get_argument('network_config_save', false) then
		local other_ssid = self:get_argument('other_ssid', false)

		local config = {}
		for _, v in ipairs(NetworkConfig.params(is_wireless)) do
			config[v] = self:get_argument(v, false)
		end

		if other_ssid then
			config['essid'] = other_ssid
		end

		local err = NetworkConfig.validate(config)
		if err then
			log.debug("validation error: " .. err)
			self:_response(type, err)
			return
		end

		if is_wireless then
			local scan, status = NetworkConfig.scan_wifi()
			local ssid_found = false
			for _, v in ipairs(scan) do
				if config.essid == v.ssid then
					ssid_found = true
				end
			end
			config['force_scan'] = not ssid_found
		end
		
		NetworkConfig.set(config, int, is_wireless)
	end

	if self:get_argument("network_ifdown", false) or self:get_argument("network_ifdownup", false) then
		log.debug("ifdown " .. int)
		util.execute("sudo netctl stop " .. int)
	end
	if self:get_argument("network_ifup", false) or self:get_argument("network_ifdownup", false) then
		log.debug("ifup " .. int)
		util.execute("sudo netctl start " .. int)
	end

	self:_response(type)
end

------------------------------------------------------------------------------------------

function _sel(param, strings, entries, contains)
	local t = {}
	local sel
	for _, entry in ipairs(entries) do
		for k, v in pairs (entry) do
			local selected = contains and string.match(param or "", k) or (param == k)
			sel = sel or selected
			t[#t+1] = { val = k, desc = strings[v] or v, selected = (selected and "selected" or "") }
		end
	end
	table.insert(t, 1, { val = "", desc = "", selected = sel and "" or "selected" })
	return t
end

-- squeezelite.html
function SqueezeliteHandler:_response(err)
	local config = SqueezeliteConfig.get()
	local t = {}

	if err then
		t['p_error'] = err and (strings['squeezelite']["error_" .. err] or 'validation error - ' .. err)
	end

	for _, v in ipairs(SqueezeliteConfig.params()) do
		t["p_"..v] = config[v]
	end
	t['p_resample_checked'] = config.resample and "checked" or ""
	t['p_vis_checked']      = config.vis and "checked" or ""
	t['p_advanced']         = self:get_argument('advanced', false) and "checked" or nil

	t['p_resample_async_checked']     = string.match(config.resample_recipe or "", "X") and "checked" or ""
	t['p_resample_exception_checked'] = string.match(config.resample_recipe or "", "E") and "checked" or ""

	-- select options require table per entry, update param with more details of options
	t['p_alsa_format']      = _sel(config.alsa_format, strings['squeezelite'],
								   { { ["16"] = "bit_16" }, { ["24"] = "bit_24" }, { ["24_3"] = "bit_24_3"} , { ["32"] = "bit_32" } })
	t['p_alsa_mmap']        = _sel(config.alsa_mmap, strings['squeezelite'], { { ["0"] = "mmap_off" }, { ["1"] = "mmap_on" } })
	t['p_dop']              = _sel(config.dop, strings['squeezelite'], { { ["1"] = "dop_supported" } })
	t['p_resample_quality'] = _sel(config.resample_recipe, strings['squeezelite'], 
								   { { ["v"] = "very_high" }, { ["h"] = "high" }, { ["m"] = "medium" }, { ["l"] = "low" },
									 { ["q"] = "quick" } }, true)
	t['p_resample_filter']  = _sel(config.resample_recipe, strings['squeezelite'], 
								   { { ["L"] = "linear" }, { ["I"] = "intermediate" }, { ["M"] = "minimum" } }, true)
	t['p_resample_steep']   = _sel(config.resample_recipe, strings['squeezelite'], 
								   { { ["s"] = "steep" } }, true)

	for _, v in ipairs({ "slimproto", "stream", "decode", "output" }) do
		t['p_loglevel_' .. v] = _sel(config['loglevel_' .. v], strings['squeezelite'], 
									 { { ["info"] = "info" }, { ["debug"] = "debug" }, { ["sdebug"] = "trace" } })
	end

	local status = util.capture('systemctl status squeezelite.service')
	if status then
		for line in string.gmatch(status, "(.-)\n") do
			local loaded, enabled = string.match(line, "Loaded: (.-) %(.-; (.-)%)")
			local active, running = string.match(line, "Active: (.-) %((.-)%)")
			if loaded and enabled then
				t['p_status'] = loaded .. " / " .. enabled
			end
			if active and running then
				t['p_active'] = active .. " / " .. running
			end
		end
	end

	if config.logfile then
		local logfile = io.open(config.logfile, "r")
		if logfile then
			logfile:close()
			t['p_log'] = util.capture('tail ' .. config.logfile)
		end
	end
	
	t['p_devices'] = {}
	local device_info = util.capture("squeezelite -l")
	local inc = {}
	if device_info then
		for line in string.gmatch(device_info, "(.-)\n") do
			local id = string.match(line, "%s*(.-)%s-%-")
			if id then
				id = string.gsub(id, "sysdefault:", "hw:")  -- replace sysdefault:* with hw:*
				id = string.gsub(id, "default:", "hw:")     -- replace default:* with hw:*
				if not inc[id] then
					table.insert(t['p_devices'], { device = id, selected = (id == config.device and "selected" or "") })
					inc[id] = 1
				end
			end
		end
	end
	if not inc[config.device] then
		-- add previously selected device at top of list if it is not included as it may have been turned off
		table.insert(t['p_devices'], 1, { device = config.device, selected = "selected" })
	end

	setmetatable(t, { __index = strings['squeezelite'] })
	self:renderResult('squeezelite.html', t)
end

function SqueezeliteHandler:get()
	self:_response()
end

function SqueezeliteHandler:post()
	self:serviceActions('squeezelite.service')

	if self:get_argument('squeezelite_config_save', false) or self:get_argument('squeezelite_config_saverestart', false) then
		local config = {}
		for _, v in ipairs(SqueezeliteConfig.params()) do
			config[v] = self:get_argument(v, false)
		end
		config.resample_recipe = self:get_argument("resample_quality", "") .. self:get_argument("resample_filter", "") .. 
			self:get_argument("resample_steep", "") .. 
			(self:get_argument("resample_async", false) and "X" or "") .. 
			(self:get_argument("resample_exception", false) and "E" or "")

		local err = SqueezeliteConfig.validate(config)
		if err then
			log.debug("validation error: " .. err)
			self:_response(err)
			return
		end
		
		SqueezeliteConfig.set(config)

		if self:get_argument('squeezelite_config_saverestart', false) then
			util.execute(string.format(service_actions['restart'][1], 'squeezelite.service'))
		end
	end

	self:_response()
end

------------------------------------------------------------------------------------------

-- squeezeserver.html
function SqueezeserverHandler:_response()
	local t = {}

	local status = util.capture('systemctl status logitechmediaserver.service')
	if status then
		for line in string.gmatch(status, "(.-)\n") do
			local loaded, enabled = string.match(line, "Loaded: (.-) %(.-; (.-)%)")
			local active, running = string.match(line, "Active: (.-) %((.-)%)")
			if loaded and enabled then
				t['p_status'] = loaded .. " / " .. enabled
			end
			if active and running then
				t['p_active'] = active .. " / " .. running
			end
		end
	end

	t['p_server_url'] = 'http://' .. (string.match(self.request['host'], "(.-):") or self.request['host']) .. ":9000"

	setmetatable(t, { __index = strings['squeezeserver'] })
	self:renderResult('squeezeserver.html', t)
end

function SqueezeserverHandler:get()
	self:_response()
end

function SqueezeserverHandler:post()
	self:serviceActions('logitechmediaserver.service')
	self:_response()
end

------------------------------------------------------------------------------------------

-- storage.html
function _ids(tab)
	local t = {}
	for _, v in ipairs(tab) do
		t[#t+1] = { id = v }
	end
	return t
end

function StorageHandler:_response(err)
	local t = {}

	if err and err ~= "" then
		log.debug("error: " .. err)
		t['p_error'] = err
	end

	local mounts = StorageConfig.get()
	
	table.sort(mounts, function(a, b) return a.mountp < b.mountp end)
	
	t['p_disks']       = _ids(StorageConfig.localdisks())
	t['p_types_local'] = _ids({ '', 'fat', 'ntfs', 'ext2', 'ext3', 'ext4' })
	t['p_types_remote']= _ids({ '', 'cifs', 'nfs', 'nfs4' })

	t['p_mountpoints'] = {}
	for _, v in ipairs(StorageConfig.mountpoints(mounts)) do
		table.insert(t['p_mountpoints'], { id = v, desc = v })
	end
	
	for _, v in ipairs(mounts) do
		t['p_mounts'] = t['p_mounts'] or {}
		table.insert(t['p_mounts'], {
			p_spec = v.spec, p_mountp = v.mountp, p_type = v.type, p_opt = v.opts, p_perm = v.perm, p_act = v.active,
			p_active = v.active and strings['storage']['active'] or strings['storage']['inactive'],
			p_action = v.active and 'unmount' or 'remount',
			p_remove = v.active and 'remove_act' or 'remove_inact',
			p_action_str = v.active and strings['storage']['unmount'] or strings['storage']['remount'],
			p_remove_str = strings['storage']['remove'],
		})
	end

	setmetatable(t, { __index = strings['storage'] })
	self:renderResult('storage.html', t)
end

function StorageHandler:get()
	self:_response()
end

function StorageHandler:post()
	local new_local   = self:get_argument('localfs_mount', false)
	local new_remote  = self:get_argument('remotefs_mount', false)
	local unmount     = self:get_argument('unmount', false)
	local remount     = self:get_argument('remount', false)
	local remove_act  = self:get_argument('remove_act', false)
	local remove_inact= self:get_argument('remove_inact', false)
	local err
	
	if new_local or new_remote then
		
		local spec = self:get_argument('spec', false)
		local mountp = self:get_argument('mountpoint', false)
		local type = self:get_argument('type', false)
		local opts = self:get_argument('options', false)
		
		local type_map = { fat = 'vfat', ntfs = 'ntfs-3g' }
		type = type_map[type] or type
		
		if new_local then
			opts = opts or "defaults,nofail"
		end
		
		if new_remote then
			opts = opts or "defaults,_netdev"
			
			if type == 'cifs' then
				-- for cifs we must make sure that either credentials or guest is added to the option string else mount.cifs may block
				local user = self:get_argument('user', false)
				local pass = self:get_argument('pass', false)
				local domain = self:get_argument('domain', false)
				if user then
					opts = opts .. ",credentials=" .. StorageConfig.cred_file(mountp, user, pass, domain)
				else
					opts = opts .. ",guest"
				end
			end

			if string.match(type, "nfs") then
				-- nfs requires helper service to be running
				util.execute("sudo systemctl enable nfs-client.target")
				util.execute("sudo systemctl start nfs-client.target")
			end
		end
		
		if spec and mountp then

			err = util.capture("sudo mount " .. (type and ("-t " .. type .. " ") or "") .. (opts and ("-o " .. opts .. " ") or "") ..
							   spec .. " " .. mountp)
		
			-- if mount worked then persist, storing opts passed not those parsed from active mounts
			if not err or err == "" then
				local mounts = StorageConfig.get()
				for _, v in ipairs(mounts) do
					if spec == v.spec and mountp == v.mountp then
						v.opts = opts
						v.perm = true
						break
					end
				end
				StorageConfig.set(mounts)
			end

			if type ~= 'cifs' then
				StorageConfig.remove_cred_file(mountp)
			end

		end
	end
	
	if unmount or remove_act then
		err = util.capture("sudo umount " .. (unmount or remove_act))
	end
	
	if remount then
		err = util.capture("sudo mount " .. remount)
	end
	
	if remove_act or remove_inact then
		-- remove mount from persited mounts
		local mounts = StorageConfig.get()
		local remove = remove_act or remove_inact
		local i = 1
		while mounts[i] do
			if remove == mounts[i].mountp then
				table.remove(mounts, i)
				break
			end
			i = i + 1
		end
		StorageConfig.set(mounts)
		StorageConfig.remove_cred_file(remove)
	end
	
	self:_response(err)
end

------------------------------------------------------------------------------------------

-- shutdown.html
function ShutdownHandler:get()
	self:renderResult('shutdown.html', strings['shutdown'])
end

function ShutdownHandler:post()
	if self:get_argument("halt", false) then
		log.debug("halt")
		self:renderResult('reboothalt.html', 
						  setmetatable({ p_message = strings['reboothalt']['halting'] }, { __index = strings['reboothalt'] }))
		util.execute("sudo halt")
	elseif self:get_argument("reboot", false) then
		log.debug("restart")
		self:renderResult('reboothalt.html', 
						  setmetatable({ p_message = strings['reboothalt']['rebooting'] }, { __index = strings['reboothalt'] }))
		util.execute("sudo reboot")
	else
		self:renderResult('shutdown.html', strings['shutdown'])
	end
end

-------------------------------------------------------------------------------------------

-- update.html
function UpdateHandler:_response(install, remove)
	local t = {}
	local existing = Update.existing()

	for _, o in ipairs(Update:options()) do
		t['p_' .. o .. '_checked'] = existing[o] and "checked" or ""
		t['p_' .. o .. '_ver']     = existing[o]
		if install and install[o] then
			t['p_' .. o .. '_checked'] = "checked"
		end
		if remove and remove[o] then
			t['p_' .. o .. '_checked'] = ""
		end
	end

	setmetatable(t, { __index = strings['update'] })
	self:renderResult('update.html', t)
end

function UpdateHandler:get()
	self:_response()
end

function UpdateHandler:post()
	local install, remove = {}, {}

	if self:get_argument("update", false) then
		Update.update()
	end

	if self:get_argument("installremove", false) then
		local existing = Update:existing()
		for _, o in ipairs(Update:options()) do
			remove[o] = not self:get_argument(o, false) and existing[o]
			install[o] = self:get_argument(o, false) and not existing[o]
		end
		Update.installremove(install, remove)
	end

	self:_response(install, remove)
end

------------------------------------------------------------------------------------------

-- log handler
function LogHandler:get(log)
	local stream = self:get_argument('stream', false)
	local lines  = self:get_argument('lines', false) or 100
	local file, fh

	if log == 'squeezelite' then
		local config = SqueezeliteConfig.get()
		file = config and config.logfile
	elseif log == 'squeezeboxserver' then
		file = '/opt/logitechmediaserver/Logs/server.log'
	elseif log == 'soa-build' then
		file = '/tmp/soa-build.log'
	end

	if file then
		fh = io.open(file, "r")
	end
	if fh == nil then
		return
	else
		fh:close()
	end

	if stream then
		-- chrome buffers responses unless use octect-stream
		self:set_header('Content-Type', 'application/octet-stream')
		self:set_chunked_write()
		util.stream("tail -n " .. lines .. " -f " .. file,
			function(chunk)
				if chunk then
					self:write(chunk .. "\r\n")
					self:flush()
				else
					self:finish()
				end
			end,
			self
		)
	else
		self:write("<pre>")
		self:write( util.capture("tail -n " .. lines .. " " .. file) )
		self:write("</pre>")
	end
end

function LogHandler:on_connection_close()
	if self.__stream_close then
		self.__stream_close()
	end
end

-------------------------------------------------------------------------------------------

-- register pages and start server
turbo.web.Application({
    { "^/$", IndexHandler },
    { "^/index%.html$", IndexHandler },
    { "^/system%.html$", SystemHandler },
    { "^/network%-(.-)%.html$", NetworkHandler },
    { "^/squeezelite%.html$", SqueezeliteHandler },
    { "^/squeezeserver%.html$", SqueezeserverHandler },
    { "^/storage%.html$", StorageHandler },
    { "^/shutdown%.html$", ShutdownHandler },
    { "^/update%.html$", UpdateHandler },
    { "^/(.-)%.log$", LogHandler },
    { "^/static/(.*)$", turbo.web.StaticFileHandler, static_path },
}):listen(PORT)

turbo.ioloop.instance():start()
