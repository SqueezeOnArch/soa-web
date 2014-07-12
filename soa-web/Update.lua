-- Update

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

local lfs, os, io, pairs, string = lfs, os, io, pairs, string
local util, cfg, log = util, cfg, log

module(...)

local scriptDir     = "/root/soa-aur/"
local updateScript  = "soa-update-all.sh"
local installScript = "soa-installremove-components.sh"

local opts = {
	squeezelite = { 'squeezelite', 'squeezelite' },
	jivelite    = { 'jivelite' },
	server78    = { 'logitechmediaserver', 'squeezeserver' },
	server79    = { 'logitechmediaserver-lms', 'squeezeserver' }
}

function options()
	return { 'squeezelite', 'jivelite', 'server78', 'server79' }
end

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
				local pac, ver = string.match(res, "(.-) (.-)\n")
				if pac == v[1] then
					t[ v[2] ] = true
				end
			end
			q:close()
		end
	end
	return t
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
			cmd = cmd .. " remove " .. k
			required = true
			if v[2] then
				cfg[ v[2] ] = nil
			end
		end
	end
	for k, _ in pairs(opts) do
		if install[k] then
			cmd = cmd .. " install " .. k
			required = true
			if v[2] then
				cfg[ v[2] ] = true
			end
		end
	end
	if required then
		log.debug("cmd: " .. cmd)
		os.execute("sudo " .. cmd .. " &>/tmp/soa-build.log &")
	end
end

function update()
	log.debug("update")
	os.execute("sudo " .. scriptDir .. updateScript .. " &>/tmp/soa-build.log &")
end
