-- StorageConfig

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

local io, string = io, string
local util, cfg, log = util, cfg, log

module(...)

local confFile = "/etc/samba/smb.conf"

function status()
	local avail, running
	local status = util.capture('systemctl status smbd')
	if status then
		for line in string.gmatch(status, "(.-)\n") do
			local l, e = string.match(line, "Loaded: (.-) %(.-; (.-)%)")
			local a, r = string.match(line, "Active: (.-) %((.-)%)")
			if l and l == 'loaded' then
				avail = true
			end
			if r and r == 'running' then
				running = true
			end
		end
	end
	return avail, running
end

function restart()
	util.execute("sudo systemctl restart smbd nmbd")
end

function start()
	util.execute("sudo systemctl enable smbd nmbd")
	util.execute("sudo systemctl start smbd nmbd")
end

function stop()
	util.execute("sudo systemctl stop smbd nmbd")
	util.execute("sudo systemctl disable smbd nmbd")
end

function get()
	local file = io.open(confFile, 'r')
	local name, group
	if file then
		for line in file:lines() do
			local n =  string.match(line, "%s*netbios%s*name%s*=%s*(.-)%s*$")
			local g = string.match(line, "workgroup%s*=%s*(.-)%s*$")
			if n then
				name = string.match(n, '^"(.-)"$') or n
			end
			if g then
				group =	string.match(g, '^"(.-)"$') or g
			end
		end
		file:close()
	end
	return name, group
end

function set(name, group)
	local tmpFile = cfg.tmpdir .. "/smbconfig.tmp"
	local ifile = io.open(confFile, 'r')
	local ofile = io.open(tmpFile, 'w')

	if ifile and ofile then

		for line in ifile:lines() do
			if string.match(line, "%s*netbios%s*name%s*=") then
				ofile:write('\tnetbios name = "' .. (name or "") .. '"\n')
			elseif string.match(line, "%s*workgroup%s*=") then
				ofile:write('\tworkgroup = "' .. (group or "") .. '"\n')
			else
				ofile:write(line .. "\n")
			end
		end
		ifile:close()
		ofile:close()

		util.execute("sudo cp " .. tmpFile .. " " .. confFile)
		util.execute("rm " .. tmpFile)

		log.debug("wrote and updated smb.conf")
	else
		log.error("unable to write smb.conf")
	end
end
