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

local lfs, os, pairs, string = lfs, os, pairs, string
local util, cfg, log = util, cfg, log

module(...)

local scriptDir     = "/root/soa-aur/"
local updateScript  = "soa-update-all.sh"
local installScript = "soa-installremove-components.sh"

local opts = {
	squeezelite = 'squeezelite',
	jivelite    = 'jivelite',
	server78    = 'logitechmediaserver',
	server79    = 'logitechmediaserver-lms',
}

function options()
	return { 'squeezelite', 'jivelite', 'server78', 'server79' }
end

function available()
	return lfs.attributes(scriptDir .. updateScript, "size") ~= nil
end

function existing()
	local t = {}
	for k, v in pairs(opts) do
	    local res = util.capture("pacman -Q " .. v)
		local pac, ver = string.match(res, "(.-) (.-)\n")
		if pac == v then
			t[k] = ver
		end
	end
	return t
end

function installremove(install, remove)
	local cmd = scriptDir .. installScript
	local required = false
	for k, _ in pairs(opts) do
		if remove[k] then
			cmd = cmd .. " remove " .. k
			required = true
		end
	end
	for k, _ in pairs(opts) do
		if install[k] then
			cmd = cmd .. " install " .. k
			required = true
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
