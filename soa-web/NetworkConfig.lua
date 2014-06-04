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

local io, string, os, ipairs, pairs, tonumber, tostring = io, string, os, ipairs, pairs, tonumber, tostring
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
		local status = util.capture("systemctl status netctl-" .. (is_wireless and "auto" or "ifplugd") .. "@" .. int .. ".service")
		config.onboot = not string.match(status or "", "disabled")
		if config.address then
			config.address, config.mask = string.match(config.address, "(.-)/(.*)")
		end
		if config.dns then
			local array = string.match(config.dns, "%((.*)%)") or ""
			config.dns1, config.dns2, config.dns3 = string.match(array .. " '' ''", "'(.-)' '(.-)' '(.-)'")
		end
		config.psk = config.key
		conf:close()
	else
		log.debug("unable to open: " .. configFilePrefix .. int)
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
	if c.mask and not _ip_validate(c.mask, true) then
		return 'mask'
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
			conf:write("Address='" .. config.address .. "/" .. config.mask .. "'\n")
			conf:write("Gateway='" .. config.gateway .. "'\n")
			conf:write("DNS=(" .. 
					   (config.dns1 and ("'" .. config.dns1 .. "'") or "") ..
					   (config.dns2 and (" '" .. config.dns2 .. "'") or "") ..
					   (config.dns3 and (" '" .. config.dns3 .. "'") or "") ..
					   ")\n")
			if config.domain then
				config:write("DNSDomain='" .. config.domain .. "'\n")
			end
		end
		
		if is_wireless then
			conf:write("Security=wpa\n")
			conf:write("ESSID='" .. (config.essid or "XXXXXX") .. "'\n")
			conf:write("Key='" .. (config.psk or "XXXXXX") .. "'\n")
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

		if config.onboot then
			if is_wireless then
				util.execute("sudo systemctl enable netctl-auto@" .. int .. ".service")
			else
				util.execute("sudo systemctl enable netctl-ifplugd@" .. int .. ".service")
			end
		else
			if is_wireless then
				util.execute("sudo systemctl disable netctl-auto@" .. int .. ".service")
			else
				util.execute("sudo systemctl disable netctl-ifplugd@" .. int .. ".service")
			end
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
