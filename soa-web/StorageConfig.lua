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

local io, string, os, lfs, ipairs, pairs, table, tonumber, tostring = io, string, os, lfs, ipairs, pairs, table, tonumber, tostring
local util, cfg, log = util, cfg, log

module(...)

local fstabLocation = "/etc/fstab"
local local_disks   = "/dev/"
local mountdir      = "/mnt/"

local storagedirs = {}
for dir in lfs.dir(mountdir) do
	if not string.match(dir, "^%.") then
		if lfs.attributes(mountdir .. dir, "mode") == "directory" then
			storagedirs[#storagedirs+1] = mountdir .. dir
		end
	end
	table.sort(storagedirs)
end

function available()
	return #storagedirs > 0
end

function _mounts()
	local mounts = {}
	local storage = {}
	for _, v in ipairs(storagedirs) do
		storage[v] = true
	end

	local cap = util.capture('mount') .. "\n"
	for line in string.gmatch(cap, "(.-)\n") do
		local spec, mountp, type, opts = string.match(line, "(.-) on (.-) type (.-) %((.-)%)")
		if spec and mountp and storage[mountp] and type and opts then
			-- mount returns fuseblk for ntfs-3g file systems, but does not understand it as a fstype
			if type == 'fuseblk' then
				type = 'ntfs-3g'
			end
			mounts[#mounts+1] = { spec = spec, mountp = mountp, type = type, opts = opts, perm = false, active = true } 
		end
	end
	return mounts
end

function get()
	-- get current active mounts
	local mounts = _mounts()

	-- update with whether they are in fstab and add other non active fstab entries from our section of fstab
	local fstab = io.open(fstabLocation, "r")
	if fstab then
		local ours = false
		for line in fstab:lines() do
			if string.match(line, "^# start added by squeeze%-web%-gui") then
				ours = true
			elseif string.match(line, "^# end added by squeeze%-web%-gui") then
				ours = false
			elseif ours then
				local spec, mountp, type, opts = string.match(line, "(.-)%s+(.-)%s+(.-)%s+(.-)%s")
				if spec and mountp and type and opts then
					local found = false
					for _, v in ipairs(mounts) do
						if spec == v.spec and mountp == v.mountp and type == v.type then
							found = true
							v.perm = true
							v.opts = opts -- use opts from fstab as more complete
							break
						end
					end
					if not found then
						mounts[#mounts+1] = { spec = spec, mountp = mountp, type = type, opts = opts, perm = true }
					end
				end
			end
		end
		fstab:close()
	else
		log.debug("unable to open: " .. fstabLocation)
	end

	return mounts
end

function mountpoints(mounts)
	local mounts = mounts or _mounts()
	local exclude, t = {}, {}
	
	-- only show available mounts
	for _, mount in ipairs(mounts) do
		exclude[mount.mountp] = true
	end
	for _, v in ipairs(storagedirs) do
	    if not exclude[v] then
			t[#t+1] = v
	    end
	end
	
	return t
end

function localdisks()
	local t = {}
	for file in lfs.dir(local_disks) do
		if string.match(file, "sd%l%d") then
			t[#t+1] = local_disks .. file
		end
	end
	table.sort(t)
	return t
end

function set(mounts)
	local tmpFile = cfg.tmpdir .. "/config.tmp-luagui"
	local fstab = io.open(fstabLocation, "r")
	local tmp   = io.open(tmpFile, "w")

	if fstab and tmp then
		-- copy over file excluding portion marked as ours
		local ours = false
		for line in fstab:lines() do
			if string.match(line, "^# start added by soa%-web") then
				ours = true
			elseif string.match(line, "^# end added by soa%-web") then
				ours = false
			elseif not ours then
				tmp:write(line .. "\n")
			end
		end
		-- add our new section
		tmp:write("# start added by soa-web\n")
		for _, v in ipairs(mounts) do
			if v.perm then
				tmp:write(v.spec .. "\t" .. v.mountp .. "\t" .. v.type .. "\t" .. (v.opts or "defaults") .. "\t0\t0\n")
			end
		end
		tmp:write("# end added by soa-web\n")

		tmp:close()
		fstab:close()

		util.execute("sudo cp " .. tmpFile .. " " .. fstabLocation)
		util.execute("rm " .. tmpFile)

		log.debug("wrote and updated fstab")
	else
		if not fstab then
			log.error("unable to open: " .. fstabLocation)
		end
		if not tmp then
			log.error("unable to open: " .. tmpFile)
		end
	end
end

function cred_file(mountp, user, pass, domain)
	local tmpFile = cfg.tmpdir .. "/config.tmp"

	local credFile = 'cifs' .. string.gsub(mountp, "/", "-")
	
	local tmp = io.open(tmpFile, "w")
	if tmp then
		tmp:write("# Created by soa-web\n")
		tmp:write("username=" .. (user or "") .. "\n")
		tmp:write("password=" .. (pass or "") .. "\n")
		tmp:write("domain=" .. (domain or "") .. "\n")
		tmp:close()
		
		util.execute("sudo cp " .. tmpFile .. " /etc/credentials/" .. credFile)
		util.execute("sudo chown root.root /etc/credentials/" .. credFile)
		util.execute("sudo chmod 600 /etc/credentials/" .. credFile)
		util.execute("rm " .. tmpFile)
		
		log.debug("updated credentials " .. credFile)
	else
		log.error("unable to open: " .. tmpFile)
	end
	
	return '/etc/credentials/' .. credFile
end
