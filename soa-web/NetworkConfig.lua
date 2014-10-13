-- NetworkConfig

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

local io, string, os, ipairs, pairs, tonumber, tostring, bit = io, string, os, ipairs, pairs, tonumber, tostring, bit
local util, cfg, log = util, cfg, log

module(...)

local configFilePrefix = "/etc/netctl/"

function params(wireless)
	local t = {
		'interface', 'connection', 'ip', 'address', 'mask', 'gateway', 'dns1', 'dns2', 'dns3', 'domain', 
		'dhcp', 'onboot'
	}
	if wireless then
		t[#t+1] = 'essid'
		t[#t+1] = 'psk'
		t[#t+1] = 'country'
	end
	return t
end

function _tomask(cidr)
	local bits = 0
	for i = 32 - (tonumber(cidr) or 0), 31 do
		bits = bit.bor(bits, bit.lshift(1, i))
	end
	return
		bit.rshift(bit.band(bits, 0xff000000), 24) .. "." ..
		bit.rshift(bit.band(bits, 0x00ff0000), 16) .. "." ..
		bit.rshift(bit.band(bits, 0x0000ff00),  8) .. "." ..
		bit.band(bits, 0x000000ff)
end

function get(int, is_wireless)
	local config = {}

	local conf = io.open(configFilePrefix .. int, "r")
	if conf then
		for line in conf:lines() do
			local k, v = string.match(line, "^(.-)=(.*)")
			if k and v then
				config[ string.lower(k) ] = string.match(v, "^'(.*)'$") or v
			end
		end
		config.dhcp = (config.ip == "dhcp")
		local status1 = util.capture("netctl is-enabled " .. int)
		local status2 = util.capture("systemctl status netctl-" .. (is_wireless and "auto" or "ifplugd") .. "@" .. int .. ".service")
		config.onboot = string.match(status1 or "", "enabled") or not string.match(status2 or "", "disabled")
		if config.address then
			config.address, config.mask = string.match(config.address, "(.-)/(.*)")
		end
		if config.mask and string.match(config.mask, "%d+") and not string.match(config.mask, "%d+%.%d+") then
			config.mask = _tomask(config.mask)
		end
		if config.dns then
			local array = string.match(config.dns, "%((.*)%)") or ""
			config.dns1, config.dns2, config.dns3 = string.match(array .. " '' ''", "'(.-)' '(.-)' '(.-)'")
		end
		if config.dnsdomain then
			config.domain = config.dnsdomain
		end
		if not config.interface then
			config.interface = int
		end
		if not config.connection then
			config.connection = is_wireless and "wireless" or "ethernet"
		end
		config.psk = config.key
		conf:close()
	else
		log.debug("unable to open: " .. configFilePrefix .. int)
		config.dhcp = true
		config.onboot = true
		config.interface = int
		config.connection = is_wireless and "wireless" or "ethernet"
	end

	return config
end

function scan_wifi()
	local status = {}
	local scan   = {}

	local step1 = util.capture("sudo wpa_cli status")
	for line in string.gmatch(step1, "(.-)\n") do
		local k, v = string.match(line, "(.-)=(.*)")
		if k and v then
			status[k] = string.lower(v)
		end
	end	

	local step2 = util.capture("sudo wpa_cli scan")
	if string.match(step2, "OK") then
		local step3 = util.capture("sudo wpa_cli scan_results")
		for line in string.gmatch(step3, "(.-)\n") do
			local bssid, freq, signal, flags, ssid = string.match(line, "(%x+:%x+:%x+:%x+:%x+:%x+)%s+(.+)%s+(.+)%s+(.+)%s+(.+)")
			if ssid then
				scan[#scan+1] = { ssid = ssid, flags = flags, signal = tonumber(signal) }
			end
		end
	end

	return scan, status
end

function _ip_validate(s, mask)
	local ip1, ip2, ip3, ip4 = string.match(s, "^(%d+)%.(%d+)%.(%d+)%.(%d+)$")
	if ip1 and ip2 and ip3 and ip4 then
		ip1 = tonumber(ip1)
		ip2 = tonumber(ip2)
		ip3 = tonumber(ip3)
		ip4 = tonumber(ip4)
		if mask and ip1 >= 0 and ip1 <= 255 and ip2 >= 0 and ip2 <= 255 and ip3 >= 0 and ip3 <= 255 and ip4 >= 0 and ip4 <= 255 then
			local bits = bit.tobit(bit.lshift(ip1, 24) + bit.lshift(ip2, 16) + bit.lshift(ip3, 8) + ip4)
			local first
			for i = 0, 31 do
				if bit.band(bits, bit.lshift(1, i)) ~= 0 then
					first = i
					break
				end
			end
			for i = first or 0, 31 do
				if bit.band(bits, bit.lshift(1, i)) == 0 then
					return false
				end
			end
			return true
		end
		if ip1 >= 0 and ip1 < 224 and ip2 >= 0 and ip2 <= 255 and ip3 >= 0 and ip3 <= 255 and ip4 > 0 and ip4 < 255 then
			return true
		end
	end
	return false
end

function validate(c)
	-- return error token or nil
	for _, v in ipairs({ 'address', 'gateway', 'dns1', 'dns2', 'dns3' }) do
		if c[v] and not _ip_validate(c[v]) then
			return v
		end
	end
	if c.mask then
		if string.match(c.mask, "%d+") and not string.match(c.mask, "%d+%.%d+") then
			c.mask = _tomask(c.mask)
		end
		if not _ip_validate(c.mask, true) then
			return 'mask'
		end
	end
	if (c.address or c.mask or c.gateway) and not (c.address and c.mask and c.gateway) then
		return 'static'
	end
	return nil
end

function set(config, int, is_wireless)
	local configFileTmp = cfg.tmpdir .. "/ifcfg.config-luagui"
	local conf = io.open(configFileTmp, "w")

	if conf then
		conf:write("# created by soa-web " .. os.date() .. "\n")
		conf:write("Description='configuration for " .. int .. "'\n")
		conf:write("Interface=" .. int .. "\n")
		conf:write("Connection=" .. (is_wireless and "wireless" or "ethernet") .. "\n")
		
		if config.dhcp then
			conf:write("IP=dhcp\n")
		else
			conf:write("IP=static\n")
			conf:write("Address='" .. (config.address or "") .. "/" .. (config.mask or "") .. "'\n")
			conf:write("Gateway='" .. (config.gateway or "") .. "'\n")
			conf:write("DNS=(" .. 
					   (config.dns1 and ("'" .. config.dns1 .. "'") or "") ..
					   (config.dns2 and (" '" .. config.dns2 .. "'") or "") ..
					   (config.dns3 and (" '" .. config.dns3 .. "'") or "") ..
					   ")\n")
			if config.domain then
				conf:write("DNSDomain='" .. config.domain .. "'\n")
			end
		end
		
		if is_wireless then
			conf:write("Security=wpa\n")
			conf:write("ESSID='" .. (config.essid or "XXXXXXXX") .. "'\n")
			conf:write("Key='" .. (config.psk or "XXXXXXXX") .. "'\n")
			if config.country then
				conf:write("Country='" .. config.country .. "'\n")
			end
			if config.force_scan then
				conf:write("Hidden=yes\n")
			end
		end

		conf:close()

		util.execute("sudo cp " .. configFileTmp .. " " .. configFilePrefix .. int)
		util.execute("rm " .. configFileTmp)

		-- disable systemd helpers and use raw netctl
		if is_wireless then
			util.execute("sudo systemctl disable netctl-auto@" .. int .. ".service")
		else
			util.execute("sudo systemctl disable netctl-ifplugd@" .. int .. ".service")
		end

		if config.onboot then
			util.execute("sudo netctl enable " .. int)
		else
			util.execute("sudo netctl disable " .. int)
		end

		log.debug("wrote and updated config")
	else
		if not conf then
			log.error("unable to write: " .. configFileTmp)
		end
	end
end

function regions()
	return { '00', 'AT', 'AU', 'BE', 'CA', 'CH', 'CN', 'DE', 'DK', 'ES', 'FI', 'FR', 'GB', 'HK', 'HU', 'JP', 'IE', 'IL', 'IN', 'IT',
			 'NL', 'NO', 'NZ', 'PL', 'PT', 'RS', 'RU', 'SE', 'US', 'ZA' }
end
