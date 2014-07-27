-- EN Strings
return {
	['languages'] = {
		EN = "English",
		DE = "German",
		NL = "Dutch",
		SV = "Swedish",
	},
	['index'] = {
		title = "Web Configuration",
		language = "Language",
		install = "Please wait while Squeeze on Arch is installed on your device.   Current install status: ",
	},
	['system'] = {
		title = "System Configuration",
		hostname = "Hostname",
		location = "Location",
		timezone = "Time Zone",
		locale = "Locale",
		hostname_tip = "Hostname for your device",
		timezone_tip = "Select the timezone appropriate to your location",
		locale_tip = "Select the locale appropriate for your location",
		version = "Version",
		os_version = "OS Version",
		fedora_version = "Fedora Version",
		context =
		"<ul><li>Use this page to set the configurations for the linux operating system running within your device.</li>" ..
		"<li><i><b>Hostname</b></i> sets the name for your device. This may be different from the name given to the player instance running on the device. You are likely to see this name from other devices on your network if they show names of machines on your network.</li>" ..
		"<li><i><b>Location</b></i> settings enable the timezone of the device to your location.</li>" ..
		"</ul>",
	},
	['network'] = {
		title_eth  = "Ethernet Interface Configuration",
		title_wlan = "Wireless Interface Configuration",
		interface = "Interface",
		state = "State",
		ipv4 = "IP Address",
		static = "Static",
		name  = "Name",
		type  = "Type",
		wpa_state = "Wpa State",
		dhcp = "Use DHCP",
		on_boot = "On Boot",
		add_private = "User Specified (below):",
		address = "IP Address",
		mask   = "Netmask",
		gateway= "Gateway",
		dns1   = "DNS1",
		dns2   = "DNS2",
		dns3   = "DNS3",
		domain = "Domain",
		essid  = "Network Name",
		psk    = "WPA Password",
		country = "Location",
		int_down = "Interface Down",
		int_up = "Interface Up",
		int_downup = "Interface Down / Interface Up",
		none = "(none)",
		address_tip = "Enter static IP address",
		mask_tip = "Enter network mask",
		gateway_tip = "Enter router address",
		dns1_tip = "Enter 1st DNS server address",
		dns2_tip = "Enter 2nd DNS server address (optional)",
		dns3_tip = "Enter 3rd DNS server address (optional)",
		domain_tip = "Enter DNS domain (optional)",
		essid_tip = "Select network SSID",
		other_ssid_tip = "Enter SSID if not found",
		psk_tip = "Enter WPA Password",
		country_tip = "Enter location to select wireless region",
		on_boot_tip = "Enable this inteface at boot time",
		dhcp_tip = "Use DHCP to obtain IP address information",
		error_address = "Error setting IP Address",
		error_gateway = "Error setting Gateway",
		error_netmask = "Error setting Netmask",
		error_dns1 = "Error setting DNS1",
		error_dns2 = "Error setting DNS2",
		error_dns3 = "Error setting DNS3",
		error_static = "Error setting static address - IP Address, Netmask and Gateway required",
		context =
		"<ul><li>The current status of the interface is shown at the top of the page.  If no IP address is shown then the interface is not working correctly.</li>" ..
		"<li><i><b>On&nbsp;Boot</b></i> defines if the interface is activated when your device starts.  Ensure at least one of the interfaces has this set.</li>" ..
		"<li><i><b>DHCP</b></i> is normally selected to obtain IP addresing from your network.  Clear it if you prefer to define static IP address information.</li>" ..
		"<li><i>Save</i> conifiguration changes and select <i>Interface&nbsp;Down&nbsp;/&nbsp;Interface&nbsp;Up</i> to restart the interface with new parameters.</li></ul>",
		context_wifi = "<ul><li>For wireless networks select your location and press <i>Save</i> followed by <i>Interface&nbsp;Down&nbsp;/&nbsp;Interface&nbsp;Up</i>.  You can then select which network to use from the list of detected <i>Network&nbsp;Names</i> or define your own if it is hidden.  You should also specify a WPA Password.  Note that WPA/WPA2 with a pre-shared key is the only authentication option supported.</li></ul>",
		AT = "Austria",
		AU = "Australia",
		BE = "Belgium",
		CA = "Canada",
		CH = "Switzerland",
		CN = "China",
		DE = "Germany",
		DK = "Denmark",
		ES = "Spain",
		FI = "Finland",
		FR = "France",
		GB = "Great Britain",
		HK = "Hong Kong",
		HU = "Hungary",
		JP = "Japan",
		IE = "Ireland",
		IL = "Israel",
		IN = "India",
		IT = "Italy",
		NL = "Netherlands",
		NO = "Norway",
		NZ = "New Zealand",
		PL = "Poland",
		PT = "Portugal",
		RS = "Serbia",
		RU = "Russian Federation",
		SE = "Sweden",
		US = "USA",
		ZA = "South Africa",
		['00'] = "Roaming",
	},
	['squeezelite'] = {
		title = "Squeezelite Player Configuration and Control",
		name = "Name",
		audio_output = "Audio Output",
		mac  = "MAC Address",
		device = "Audio Device",
		rate = "Sample Rates",
		logfile = "Log File",
		loglevel = "Log Level",
		priority = "RT Thread Priority",
		buffer = "Buffer",
		codec = "Codecs",
		alsa = "Alsa Params",
		resample = "Resample",
		dop = "DoP",
		vis = "Visualiser", 
		other = "Other Options",
		server = "Server IP Address",
		advanced = "Advanced",
		bit_16 = "16 bit",
		bit_24 = "24 bit",
		bit_24_3 = "24_3 bit",
		bit_32 = "32 bit",
		mmap_off = "No MMAP",
		mmap_on = "MMAP",
		dop_supported = "Device supports DoP",
		name_tip = "Player name (optional)",
		device_tip = "Select output device",
		alsa_buffer_tip = "Alsa buffer size in ms or bytes (optional)",
		alsa_period_tip = "Alsa period count or size in bytes (optional)",
		alsa_format_tip = "Alsa sample format (optional)",
		alsa_mmap_tip = "Alsa MMAP support (optional)",
		rate_tip = "Max sample rate supported or comma separated list of sample rates (optional)",
		rate_delay_tip = "Delay when switching between sample rates in ms (optional)",
		dop_tip = "Enable DSD over PCM (DoP)",
		dop_delay_tip = "Delay when switching between PCM and DoP in ms (optional)",
		advanced_tip = "Show advanced options",
		resample_tip = "Enable resampling",
		vis_tip= "Enable Visualiser display in Jivelite",
		resample_recipe = "Soxr Recipe",
		resample_options = "Soxr Options",
		very_high = "Very High",
		high = "High",
		medium = "Medium",
		low = "Low",
		quick = "Quick",
		linear = "Linear Phase",
		intermediate = "Intermediate Phase",
		minimum = "Minimum Phase",
		steep = "Steep Filter",
		flags = "Flags",
		attenuation = "Attenuation",
		precision = "Precision",
		pass_end = "Passband End",
		stop_start = "Stopband Start",
		phase = "Phase",
		async = "Asynchronous",
		exception = "By Exception",
		resample_quality_tip = "Resampling Quality (higher quality uses more processing power)",
		resample_filter_tip = "Resampling Filter type",
		resample_steep_tip = "Use Steep filter",
		resample_flags_tip = "Resampling flags (hexadecimal integer), advanced use only",
		resample_attenuation_tip = "Attenuation in dB to apply to avoid clipping (defaults to 1dB if not set)",
		resample_precision_tip = "Bits of precision, (HQ = 20, VHQ = 28)",
		resample_end_tip = "Passband end as percentage (Nyquist = 100%)",
		resample_start_tip = "Stopband start as percentage (must be greater than passband end)",
		resample_phase_tip = "Phase response (0 = minimum, 50 = linear, 100 = maximum)",
		resample_async_tip = "Resample asynchronously to maximum sample rate (otherwise resamples to max synchronous rate)",
		resample_exception_tip = "Resample only when desired sample rate is not supported by ouput device",
		info = "Info",
		debug = "Debug",
		trace = "Trace",
		loglevel_slimproto_tip = "Slimproto control session logging level",
		loglevel_stream_tip = "Streaming logging level",
		loglevel_decode_tip = "Decode logging level",
		loglevel_output_tip = "Output logging level",
		logfile_tip = "Write debug output to specified file",
		buffer_stream_tip = "Stream buffer size in Kbytes (optional)",
		buffer_output_tip = "Output buffer size in Kbytes (optional)",
		codec_tip = "Comma separated list of codecs to load (optional - loads all codecs if not set)",
		priority_tip = "RT thread priority (1-99) (optional)",
		mac_tip = "Player mac address, format: ab:cd:ef:12:34:56 (optional)",
 		server_tip = "Server IP address (optional)",
		other_tip = "Other optional configuration parameters",
		error_alsa_buffer = "Error setting Alsa buffer",
		error_alsa_period = "Error setting Alsa period",
		error_rate = "Error setting sample rate",
		error_rate_delay = "Error setting sample rate change delay",
		error_dop_delay = "Error setting DoP delay",
		error_resample_precision = "Error setting ressample precision",
		error_resample_attenuation = "Error setting ressample attenuation",
		error_resample_start = "Error setting resample stopband start",
		error_resample_end = "Error setting resample stopband",
		error_resample_endstart = "Error setting resampling parameters - passband end should not overlap stopband start",
		error_resample_phase = "Error setting resample phase response",
		error_buffer_stream = "Error setting stream buffer size",
		error_buffer_output = "Error setting output buffer size",
		error_codec = "Error setting Codecs",
		error_priority = "Error setting RT Thread Priority",
		error_mac = "Error setting MAC Address",
		error_server = "Error settting Server",
		context = 
		"<ul><li>The <i><b>Status</b></i> area at the top of the page shows the current Squeezelite pPlayer status and may be refreshed by pressing the <i>Refresh</i> button. The player will be reported as <i>active / running</i> if it is running correctly. If it fails to show this then check the configuration options and restart the player.</li>" ..
		"<li>Configuration options are specified in the fields to the left.  Update each field and click <i>Save</i> to store them or <i>Save&nbsp;and&nbsp;Restart</i> to store them and then restart the player using the new options.</li>" ..
		"<li><i><b>Name</b></i> allows you to specify the player name.  If you leave it blank, you can set it from within Squeezebox Server.</i>" ..
		"<li><i><b>Audio Device</b></i> specifies which audio output device to use and should always be set.  You should normally prefer devices with names starting <i>hw:</i> to directly drive the hardware output device.  If multiple devices are listed, try each device in turn and restart the player each time to find the correct device for your DAC.</li>" ..
		"<li><i><b>Alsa&nbsp;Params</b></i> allows you to set detailed linux audio output (Alsa) parameters and is not normally needed for your device to work.  Adjust these options if the player status shows it is not running or to optimise audio playback if you experience audio drop outs. There are four parameters:" ..
		"<ul>" ..
		"<li>Alsa <i>buffer time</i> in ms, or <i>buffer size</i> in bytes; (default 40), set to a higher value if you experience drop outs.</li>" ..
		"<li>Alsa <i>period count</i> or <i>period size</i> in bytes; (default 4).</li>" ..
		"<li>Alsa <i>sample format</i> number of bits of data sent to Alsa for each sample - try 16 if other values do not work.</li>" ..
		"<li>Alsa <i>MMAP</i> enables or disables Alsa MMAP mode which reduces cpu load, try disabling if the player fails to start.</li>" ..
		"</ul>" ..
		"<li><i><b>Sample&nbsp;Rates</b></i> allows you to specify the sample rates supported by the device so that it does not need to be present when Squeezelite is started.  Ether specify a single <i>maximum</i> sample rate, or specify all supported rates separated by commas.  You may also specify a delay in ms to add when changing sample rates if you DAC requires this.</li>" ..
		"<li><i><b>Dop</b></i> enables you to select that your DAC supports DSD over PCM (DoP) playback. You may also specify a delay in ms when switching between PCM and DoP modes.</li></ul>",
		context_resample = 
		"<p><ul><li><i><b>Resample</b></i> enables software resampling (upsampling) using the high quality SoX Resampler library.  By default audio is upsampled to the maximum synchronous sample rate supported by the output device.</li>" ..
		"<li>Selecting <i><b>Asychronous</b></i> will always resample to the maximum output sample rate.  Selecting <i><b>By Exception</b></i> will only resample when the output device does not support the sample rate of the track being played.</li>" .. 
		"<li><i><b>Soxr&nbsp;Recipe</b></i> specifies the base Soxr recipe to be used:" ..
		"<ul><li><i>Quality</i> selects the quality of resampling. It is recommended that only <i>High</i> quality (the default) or <i>Very High</i> quality is used. Note that higher quality requires more cpu processing power and this increases with sample rate.</li>" ..
		"<li><i>Filter</i> selects the filter phase response to use." ..
		"<li><i>Steep</i> selects the whether to use a steep cutoff filter.</li></ul>"..
		"<li><i><b>Soxr&nbsp;Options</b></i> specifies advanced options which provided fine grain adjustment:"..
		"<ul><li><i>Flags</i> specifies Soxr option flags in hexadecimal (advanced users only).</li>"..
		"<li><i>Attenuation</i> specifies attenuation in dB to apply to avoid audio clipping during resampling (defaults to 1dB).</li>"..
		"<li><i>Passband End</i> specifies where the passband ends as percentage; 100 is the Nyquist frequency.</li>"..
		"<li><i>Stopband Start</i> specifies where the stopband starts as percentage; 100 is the Nyquist frequency.</li>"..
		"<li><i>Phase Response</i> specifies the filter phase between 0 and 100; 0 = Minimum phase recipe, 25 = Intermediate phase recipe and 50 = Linear phase recipe.</li>" ..
		"</ul>",
		context_advanced = 
		"<p><ul><li><i><b>Advanced</b></i> shows additional options which you will normally not need to adjust. These include logging which is used to help debug problems.</li>" ..
		"<li>Adjust <i><b>Log&nbsp;Level</b></i> for each of the four logging categories to adjust the level of logging information written to the logfile and shown in the log window at the bottom of this page. Click in the log window to start and stop update of the log window.</li></ul>",
	},
	['squeezeserver'] = {
		title = "Squeeze Server Control",
		web_interface = "SqueezeServer Web Interface",
		context =
		"<ul><li>The <i><b>Status</b></i> area at the top of the page shows the current status of the local Squeezebox Server which can run on your device.  It may be refreshed by pressing the <i>Refresh</i> button. The server can be <i>Enable</i>d, <i>Disable</i>d and <i>Restart</i>ed  using the respective buttons. The server will be reported as <i>active / running</i> if it is running correctly.</li>" ..
		"<li>If you have already have a Squeezebox server running on a different machine, you do not need to enable this server.</li>" ..
		"<li>Use the <i>SqueezeServer&nbsp;Web&nbsp;Interface</i> button to open a web session to the local Squeezebox Server if it is running.</li></ul>",
	},
	['storage'] = {
		title = "Storage",
		mounts = "File Systems",
		localfs = "Local Disk",
		remotefs = "Network Share",
		disk = "Disk",
		network = "Network Share",
		user = "User",
		pass = "Password",
		domain = "Domain",
		mountpoint = "Mountpoint",
		type = "Type",
		options = "Options",
		add = "Add",
		remove = "Remove",
		unmount = "Unmount",
		remount = "Remount",
		active = "active",
		inactive = "inactive",
		samba = "Samba Server",
		nb_name = "Samba Name",
		nb_group = "Samba Workgroup",
		mountpoint_tip = "Location where mount appears on device filesystem",
		disk_tip = "Disk to mount",
		network_tip = "Network share to mount",
		type_tip = "Type of disk/share being mounted",
		user_tip = "Username for CIFS mount",
		pass_tip = "Password for CIFS mount",
		domain_tip = "Domain for CIFS mount (optional)",
		options_tip = "Additional mount options",
		samba_tip = "Enable Samba server",
		nb_name_tip = "Netbios name for samba file sharing",
		nb_group_tip = "Workgroup for Samba file sharing",
		context =
		"<ul><li>Use this menu to attach (mount) local and remote disks to your device for use with the internal Squeezebox Server.</li>" ..
		"<li>The <i><b>Local&nbsp;Disk</b></i> section is used to attach local disks. Select one of the mountpoint options. This is the path where it will appear on the device file system. Select one of the disk options. You will not normally need to select the type of the disk as this is detected automatically from its format.  Click <i>Add</i> to attach the disk to the device. If this is sucessful then an entry will appear in the <i>Mounted&nbsp;File&nbsp;Systems</i> area at the top of the page otherwise an error will be shown. If your disk has multiple partitions you may need to try each disk option in turn to find the correct one for your files.</li>" ..
		"<li>The <i><b>Network&nbsp;Share</b></i> section is used to attach network shares. Select one of the mountpoint options. Then add the network share location and select the type of network share.  For Windows (Cifs) shares you will also be asked for a username, password and domain. You may not need to include all of these details.  For NFS shares the default version is version 4.  To use NFS version 3 add <i>vers=3</i> to the options field.  Click <i>Add</i> to attach to the network shared. If this is successful then an entry will appear in the <i>Mounted&nbsp;File&nbsp;Systems</i> area at the top of the page otherwise an error will be shown.  The Network&nbsp;Share location should be of the form of one of the following:" ..
		"<ul><li><b>//MyNAS/Music</b> for a windows share called <i>Music</i> on a NAS or file server called <i>MyNAS</i></li>" ..
		"<li><b>//192.168.1.100/Music</b> for a windows share called <i>Music</i> on a NAS or file server with IP address <i>192.168.1.100</i></li>" ..
		"<li><b>Machine:/path</b> for an NFS share <i>/path</i> on a NAS or file server called <i>Machine</i></li></ul>" ..
		"<li>Mounted file systems will be re-attached when the device restarts if they are available.  To disconnect them click the <i>Remove</i> button alongside the mount entry in the <i>Mounted&nbsp;File&nbsp;Systems</i> area.</li>" ..
		"<li>If your music library contains artists, albums or titles with Unicode characters such as accents and umlauts then you should add the option <b>iocharset=utf8</b> to the options field.</li>" ..
		"<li>The <i><b>Samba&nbsp;Server</b></i> section is used to configure Windows file sharing (Samba) from the device.  When enabled any local disks or network shares mounted in this menu will be available as a windows file share from other devices on your network.  Set the <i>Samba Name</i> to be unique on your network and the <i>Samba Workgroup</i> to match the setting in the rest of your devices.</li>" ..
		"</ul>",
	},
	['shutdown'] = {
		title = "Shutdown: Reboot or Halt the device",
		control = "Control",
		halt = "Halt",
		halt_desc = "To halt device.  Wait 30 seconds before removing power.",
		reboot = "Reboot",
		reboot_desc = "To reboot the device.",
		context =
		"<ul><li>Use this menu to reboot or shutdown (halt) your device.</li>" ..
		"<li>Please wait 30 seconds after halting the device before removing the power.</li></ul>",
	},
	['reboothalt'] = {
		halting = "Device shutting down - please wait 30 seconds before removing power",
		rebooting = "Device rebooting",
	},
	['update'] = {
		title = "Update",
		installremove = "Install/Remove",
		squeezelite = "Squeezelite",
		server78 = "Squeeze Server 7.8",
		server79 = "Squeeze Server 7.9",
		jivelite = "Jivelite",
		kernel = "Custom Kernel",
		update = "Update",
		update_desc = "Update system and all installed components",
		context =
		"<ul><li>Use this menu to install or remove optional Squeeze on Arch components and to update installed components.</li>" ..
		"<li><i><b>Install/Remove</b></i> allows you to add or remove optional components.  Select components to install and then press the <i>Install/Remove</i> button.  Installable options are:" ..
		"<ul><li>Squeezelite - audio playback application (required if you want audio playback)</li>" ..
		"<li>Jivelite - HDMI user interface (install for user interface on your device)</li>" ..
		"<li>Squeeze Server 7.8 - stable version of Logitech media server 7.8</li>"..
		"<li>Squeeze Server 7.9 - beta version of Logitech media server 7.9 which tracks ongoing developments and may be unstable.  Note: only one version of Squeeze Server can be installed at one time.</li>" ..
		"<li>Custom Kernel - SoA updated linux kernel with additional capablities such as enhanced spdif support.</li>" ..
		"</ul>" ..
		"<li>Select <i><b>Update</b></i> to update the Arch linux system and all installed Squeeze on Arch software components.  This can take some time.</li>" ..
		"<li>Progress activity for installation and updates are shown in the box below.  You may pause/unpause this display by clicking in the box.</li></ul>",
	},
	['header'] = {
		home = "Home",
		system = "System",
		ethernet = "Ethernet Interface",
		wireless = "Wireless Interface",
		storage = "Storage",
		shutdown = "Shutdown",
		help = "Help",
		squeezelite = "Squeezelite Player",
		squeezeserver = "Squeeze Server",
		update = "Update",
	},
	['footer'] = {
		copyright = "Copyright",
		version = "Version",
	},
	['base'] = { -- these are shared between all pages
		status = "Status",
		active = "Active",
		service = "Service",
		refresh = "Refresh",
		enable  = "Enable",
		disable = "Disable",
		restart = "Restart",
		reset   = "Reset",
		save    = "Save",
		save_restart = "Save and Restart",
		configuration = "Configuration",
		options = "Options",
		help = "Help",
	},
}
