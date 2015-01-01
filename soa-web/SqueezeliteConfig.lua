-- SqueezeliteConfig - shared between soa-web and jivelite

-- Squeeze on Arch (SOA) Web Configuration and Control Interface
--
-- Copyright (C) 2014-2015 Adrian Smith <triode1@btinternet.com>
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

local io, string, os, tonumber, tostring, ipairs = io, string, os, tonumber, tostring, ipairs
local util, cfg, log = util, cfg, log

module(...)

local configFile    = "/etc/squeezelite.conf"

function params()
	return {
		'name', 'device', 'alsa_buffer', 'alsa_period', 'alsa_format', 'alsa_mmap', 'rate', 'rate_delay', 'dop', 'dop_delay',
		'vis', 'resample',
		'resample_recipe', 'resample_flags', 'resample_attenuation', 'resample_precision',
		'resample_end', 'resample_start', 'resample_phase',
		'loglevel_slimproto', 'loglevel_stream', 'loglevel_decode', 'loglevel_output',
		'logfile', 'buffer_stream', 'buffer_output', 'codec', 'exclude', 'priority', 'mac', 'server', 'other'
	}
end

function get()
	local c = {}

	local conf = io.open(configFile, "r")
	if conf == nil then
		log.error("unable to read: " .. configFile)
		return c
	end

	for line in conf:lines() do
		if string.match(line, "NAME") then
			c.name = string.match(line, '^NAME="%-n%s(.-)"')
		end
		if string.match(line, "AUDIO_DEV") then
			c.device = string.match(line, '^AUDIO_DEV="%-o%s(.-)"')
		end
		if string.match(line, "ALSA_PARAMS") then
			local alsa = (string.match(line, '^ALSA_PARAMS="%-a%s(.-)"') or "") .. ":::::"
			c.alsa_buffer, c.alsa_period, c.alsa_format, c.alsa_mmap = string.match(alsa, "(.-):(.-):(.-):(.-):")
		end
		if string.match(line, "MAX_RATE") then	
			local rate = (string.match(line, '^MAX_RATE="%-r%s(.-)"') or "") .. "::"
			c.rate, c.rate_delay = string.match(rate, "(.-):(.-):")
		end
		if string.match(line, "DOP") then
			c.dop = string.match(line, '^DOP="%-D') and "1" or false
			c.dop_delay = string.match(line, '^DOP="%-D%s(.-)"')
		end
		if string.match(line, "UPSAMPLE") then
			c.resample = string.match(line, '^UPSAMPLE="%-u')
			local params = (string.match(line, '^UPSAMPLE="%-u%s(.-)"') or "") .. ":::::::"
			c.resample_recipe, c.resample_flags, c.resample_attenuation, c.resample_precision, c.resample_end, c.resample_start,
			c.resample_phase = string.match(params, "(.-):(.-):(.-):(.-):(.-):(.-):(.-):")
		end
		if string.match(line, "VISULIZER") then
			c.vis = string.match(line, '^VISULIZER="%-v"') and true or false
		end
		if string.match(line, "LOG_LEVEL") then
			local loglevel = (string.match(line, '^LOG_LEVEL="%-d%s(.-)"') or "") .. " "
			c.loglevel_slimproto = string.match(loglevel, "slimproto=(.-)%s")
			c.loglevel_stream    = string.match(loglevel, "stream=(.-)%s")
			c.loglevel_decode    = string.match(loglevel, "decode=(.-)%s")
			c.loglevel_output    = string.match(loglevel, "output=(.-)%s")
		end
		if string.match(line, "LOG_FILE") then
			c.logfile = string.match(line, '^LOG_FILE="%-f%s(.-)"')
		end
		if string.match(line, "BUFFER") then
			local buffer = (string.match(line, '^BUFFER="%-b%s(.-)"') or "") .. "::"
			c.buffer_stream, c.buffer_output = string.match(buffer, "(.-):(.-):")
		end
		if string.match(line, "CODEC") then
			c.codec = string.match(line, '^CODEC="%-c%s(.-)"')
		end
		if string.match(line, "EXCLUDE_CODEC") then
			c.exclude = string.match(line, '^EXCLUDE_CODEC="%-e%s(.-)"')
		end
		if string.match(line, "PRIORITY") then
			c.priority = string.match(line, '^PRIORITY="%-p%s(.-)"')
		end
		if string.match(line, "MAC") then	
			c.mac = string.match(line, '^MAC="%-m%s(.-)"')
		end
		if string.match(line, "SERVER_IP") then
			c.server = string.match(line, '^SERVER_IP="%-s%s(.-)"')
		end
		if string.match(line, "OPTIONS") then
			c.other = string.match(line, '^OPTIONS="(.-)"')
		end
	end

	conf:close()

	return c
end

local function commalist(str, regexp)
	str = str .. ','
	regexp = "^" .. regexp .. "$"
	local match = false
	for w in string.gmatch(str, "(.-),") do
		if not string.match(w, regexp) then
			return false
		end
		match = true
	end
	return match
end

function validate(c)
	-- return error token or nil
	-- may change c for automagic...
	if c.name and string.match(c.name, "^(.-)%s*$") then
		c.name = string.match(c.name, "^(.-)%s*$")
	end
	-- ints
	for _, v in ipairs({ 'alsa_buffer', 'alsa_period', 'rate_delay', 'dop_delay', 'buffer_stream', 'buffer_output',
						 'resample_precision' }) do
		if c[v] and not string.match(c[v], "^%d+$") then
			return v
		end
	end
	-- float
	for _, v in ipairs({ 'resample_attenuation' }) do
		if c[v] and not (string.match(c[v], "^%d+$") or string.match(c[v], "^%d+%.%d+$")) then
			return v
		end
	end
	-- percent 0-200
	for _, v in ipairs({ 'resample_end', 'resample_start' }) do
		if c[v] and not	((string.match(c[v], "^%d+$") or string.match(c[v], "^%d+%.%d+$")) and tonumber(c[v]) >= 0 and tonumber(c[v]) <= 200) then
			return v
		end
	end
	-- percent 0-100
	for _, v in ipairs({ 'resample_phase' }) do
		if c[v] and not	((string.match(c[v], "^%d+$") or string.match(c[v], "^%d+%.%d+$")) and tonumber(c[v]) >= 0 and tonumber(c[v]) <= 100) then
			return v
		end
	end
	-- hex
	if c.resample_flags and not string.match(c.resample_flags, "^%x+$") then
		return 'resample_flags'
	end
	-- stopband should start after passband has ended
	if c.resample_start and c.resample_end and tonumber(c.resample_start) < tonumber(c.resample_end) then
		return 'resample_endstart'
	end
	if c.mac and not string.match(c.mac, "%x%x:%x%x:%x%x:%x%x:%x%x:%x%x") then
		return 'mac'
	end
	if c.priority and not (string.match(c.priority, "^%d+$") and tonumber(c.priority) >= 1 and tonumber(c.priority) <= 99) then
		return 'priority'
	end
	if c.rate and not (string.match(c.rate, "^%d+$") or string.match(c.rate, "^%d+%-%d+$") or commalist(c.rate,"%d+")) then
		return 'rate'
	end
	if c.codec and not commalist(c.codec, "%l+") then
		return 'codec'
	end
	if c.server and not (string.match(c.server, "^%d+%.%d+%.%d+%.%d+$") or c.server == '^localhost$') then
		return 'server'
	end
	return nil
end

function set(c)
	local configFileTmp = cfg.tmpdir .. "/squeezelite.config-luagui"

	local outconf = io.open(configFileTmp, "w")

	if outconf then
		local alsa, rate, buffer, resample_params, loglevel

		if c.alsa_buffer or c.alsa_period or c.alsa_format or c.alsa_mmap then
			alsa = (c.alsa_buffer or "") .. ":" .. (c.alsa_period or "") .. ":" .. (c.alsa_format or "") .. ":" .. (c.alsa_mmap or "")
		end
		if c.rate or c.rate_delay then
			rate = (c.rate or "") .. ":" .. (c.rate_delay or "")
		end
		if c.buffer_stream or c.buffer_output then
			buffer = (c.buffer_stream or "") .. ":" .. (c.buffer_output or "")
		end
		if c.resample_recipe or c.resample_flags or c.resample_attenuation or c.resample_precision or c.resample_end or c.resample_start
			or c.resample_phase then
			resample_params = 
				(c.resample_recipe or "") .. ":" .. (c.resample_flags or "") .. ":" .. (c.resample_attenuation or "") .. ":" ..
				(c.resample_precision or "") .. ":" .. (c.resample_end or "") .. ":" .. (c.resample_start or "") .. ":" .. 
				(c.resample_phase or "")
		end
		for _, v in ipairs({ "slimproto", "stream", "decode", "output" }) do
			if c["loglevel_" .. v] then
				loglevel = (loglevel and (loglevel .. " ") or "") .. "-d " .. v .. "=" .. c["loglevel_" .. v]
			end
		end

		outconf:write("# created by soa-web " .. os.date() .. "\n")

		if c.name     then outconf:write('NAME="-n ' .. c.name .. '"\n') end
		if c.device   then outconf:write('AUDIO_DEV="-o ' .. c.device .. '"\n') end
		if alsa       then outconf:write('ALSA_PARAMS="-a ' .. alsa .. '"\n') end
		if rate       then outconf:write('MAX_RATE="-r ' .. rate .. '"\n') end
		if buffer     then outconf:write('BUFFER="-b ' .. buffer .. '"\n') end
		if c.mac      then outconf:write('MAC="-m ' .. c.mac .. '"\n') end
		if c.priority then outconf:write('PRIORITY="-p ' .. c.priority .. '"\n') end
		if c.buffer   then outconf:write('BUFFER="-b ' .. c.buffer .. '"\n') end
		if c.codec    then outconf:write('CODEC="-c ' .. c.codec .. '"\n') end
		if c.exclude  then outconf:write('EXCLUDE_CODEC="-e ' .. c.exclude .. '"\n') end
		if c.logfile  then outconf:write('LOG_FILE="-f ' .. c.logfile .. '"\n') end
		if loglevel   then outconf:write('LOG_LEVEL="' .. loglevel .. '"\n') end
		if c.vis      then outconf:write('VISULIZER="-v"\n') end
		if c.server   then outconf:write('SERVER_IP="-s ' .. c.server .. '"\n') end
		if c.other    then outconf:write('OPTIONS="' .. c.other .. '"\n') end
		if c.resample and resample_params then
			outconf:write('UPSAMPLE="-u ' .. resample_params .. '"\n')
		elseif c.resample then
			outconf:write('UPSAMPLE="-u"\n')
		end
		if c.dop and c.dop_delay then
			outconf:write('DOP="-D ' .. c.dop_delay .. '"\n')
		elseif c.dop then
			outconf:write('DOP="-D"\n')
		end
		
		outconf:close()
		
		util.execute("sudo cp " .. configFileTmp .. " " .. configFile)
		util.execute("rm " .. configFileTmp)

		log.debug("wrote and updated config")
	else
		log.error("unable to write: " .. configFileTmp)
	end
end
