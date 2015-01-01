-- Update

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

local lfs, os, io, ipairs, pairs, string = lfs, os, io, ipairs, pairs, string
local util, cfg, log = util, cfg, log

module(...)

local scriptDir     = "/aur/soa-aur/"
local updateScript  = "soa-update-all.sh"
local installScript = "soa-installremove-components.sh"
local cleanScript   = "soa-clean.sh"
local soaReinstallScript = "/root/soa-reinstall.sh"

local opts = {
	squeezelite = { 'squeezelite', 'squeezelite' },
	jivelite    = { 'jivelite' },
	server78    = { 'logitechmediaserver', 'squeezeserver' },
	server79    = { 'logitechmediaserver-lms', 'squeezeserver' }
}
local kernels = {
	{ 'linux-wandboard-soa', 'linux-wandboard' },
	{ 'linux-sun7i-soa',     'linux-sun7i'     },
	{ 'linux-raspberrypi-latest', 'linux-raspberrypi' }
}
local keys_opts = {}

function available()
	return lfs.attributes(scriptDir .. updateScript, "size") ~= nil
end

-- called at startup so don't use util.capture
function installed()
	local t = {}
	for k, v in pairs(opts) do
		local q = io.popen("pacman -Q " .. v[1] .. " 2>/dev/null")
		if q then
			for res in q:lines() do
				local pac, ver = string.match(res, "(.-) (.-)")
				if pac == v[1] and v[2] then
					t[ v[2] ] = true
				end
			end
			q:close()
		end
		keys_opts[#keys_opts+1] = k
	end
	-- add option entry for installable kernel if it is or can be installed
	for _, v in ipairs(kernels) do
		for _, kern in ipairs(v) do
			local q = io.popen("pacman -Q " .. kern .. " 2>/dev/null")
			if q then
				for res in q:lines() do
					local pac, ver = string.match(res, "(.-) (.-)")
					if pac == kern then
						opts['kernel'] = v
						keys_opts[#keys_opts+1] = 'kernel'
					end
				end
				q:close()
			end
			if keys_opts[#keys_opts] == 'kernel' then break	end
		end
		if keys_opts[#keys_opts] == 'kernel' then break	end
	end
	-- test for reinstall soa script
	t.reinstall = lfs.attributes(soaReinstallScript) ~= nil
	return t
end

function options()
	return keys_opts
end

function existing()
	local t = {}
	for k, v in pairs(opts) do
	    local res = util.capture("pacman -Q " .. v[1])
		local pac, ver = string.match(res, "(.-) (.-)\n")
		if pac == v[1] then
			t[k] = ver
		end
	end
	return t
end

function installremove(install, remove)
	local cmd = scriptDir .. installScript
	local required = false
	for k, v in pairs(opts) do
		if remove[k] then
			cmd = cmd .. " remove " .. ((k ~= 'kernel') and k or v[1])
			required = true
			if v[2] then
				cfg[ v[2] ] = nil
			end
		end
	end
	for k, v in pairs(opts) do
		if install[k] then
			cmd = cmd .. " install " .. ((k ~= 'kernel') and k or v[1])
			required = true
			if v[2] then
				cfg[ v[2] ] = true
			end
		end
	end
	if required then
		log.debug("cmd: " .. cmd)
		os.execute("sudo -u aur " .. cmd .. " &>/tmp/soa-build.log &")
	end
end

function clean(force)
	log.debug("clean")
	os.execute("sudo -u aur " .. scriptDir .. cleanScript .. (force and " -f" or "") .. " &>/tmp/soa-build.log &")
end

function update()
	log.debug("update")
	os.execute("sudo -u aur " .. scriptDir .. updateScript .. " &>/tmp/soa-build.log &")
end

function reinstall()
	log.debug("reinstall soa")
	os.execute("sudo " .. soaReinstallScript .. " yes &>/tmp/soa-build.log &")
end
