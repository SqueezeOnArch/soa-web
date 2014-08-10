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

local io, string, pairs = io, string, pairs
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
	local path, readonly, paths = {}, {}, {}
	if file then
		local sect
		for line in file:lines() do
			if string.match(line, "^#") or string.match(line, "^;") then
				-- comment
			else
				local s = string.match(line, "%s*%[(.-)%]")
				if s then
					sect = s
				end
				if sect == 'global' then
					local n = string.match(line, "%s*netbios%s*name%s*=%s*(.-)%s*$")
					local g = string.match(line, "%s*workgroup%s*=%s*(.-)%s*$")
					if n then
						name = string.match(n, '^"(.-)"$') or n
					end
					if g then
						group =	string.match(g, '^"(.-)"$') or g
					end
				else
					local p = string.match(line, "%s*path%s*=%s*(.-)%s*$")
					local r = string.match(line, "%s*read only%s*=%s*(.-)%s*$")
					local w = string.match(line, "%s*writeable%s*=%s*(.-)%s*$") or string.match(line, "%s*write ok%s*=%s*(.-)%s*$")
					if p then
						path[sect] = p
					end
					if (r and r == 'yes') or (w and w == 'no') then
						readonly[sect] = 'ro'
					end
				end
			end
		end
		file:close()
		for k, v in pairs(path) do
			paths[v] = readonly[k] or 'rw'
		end
	end
	return name, group, paths
end

function set(name, group)
	local tmpFile = cfg.tmpdir .. "/smbconfig.tmp"
	local ifile = io.open(confFile, 'r')
	local ofile = io.open(tmpFile, 'w')

	if ifile and ofile then

		for line in ifile:lines() do
			if string.match(line, "%s*netbios%s*name%s*=") then
				ofile:write('netbios name = "' .. (name or "") .. '"\n')
			elseif string.match(line, "%s*workgroup%s*=") then
				ofile:write('workgroup = "' .. (group or "") .. '"\n')
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
