-- IT Strings
return {
	['languages'] = {
		EN = "Inglese",
		DE = "Tedesco",
		NL = "Olandese",
		SV = "Svedese",
		IT = "Italiano",
	},
	['index'] = {
		title = "Configurazione Web",
		language = "Lingua",
		install = "Si prega di attendere il completamento dell' installazione di Squeeze on Arch sul tuo dispositivo. Stato attuale dell' installazione: ",
	},
	['system'] = {
		title = "Configurazione di Sistema",
		hostname = "Hostname",
		location = "Localizzazione",
		timezone = "Fuso Orario",
		hostname_tip = "Hostname del tuo dispositivo",
		timezone_tip = "Seleziona il fuso orario di appartenenza",
		locale_tip = "Seleziona la localitá di appartenenza",
		context =
		"<ul><li>Da questa pagina è possibile impostare i parametri relativi al sistema operativo Linux installato sul tuo dispositivo.</li>" ..
		"<li><i><b>Hostname</b></i> consente di assegnare un nome al tuo dispositivo che potrebbe essere diverso dal nome del Player in uso. Questo nome potrebbe anche comparire su altri dispositivi che sono in grado di visualizzare i nomi di tutte le  macchine appartenenti alla tua Rete.</li>" ..
		"<li><i><b>Localizzazione</b></i> consente di impostare il fuso orario per la tua Nazione.</li>" ..
		"</ul>",
	},
	['network'] = {
		title_eth  = "Configurazione Interfaccia Rete Ethernet",
		title_wlan = "Configurazione Interfaccia Rete Senza Fili",
		interface = "Interfaccia",
		state = "Stato",
		ipv4 = "Indirizzo IP",
		static = "Statico",
		name  = "Nome",
		type  = "Tipo",
		wpa_state = "Stato WPA",
		dhcp = "Usa DHCP",
		on_boot = "All' avvio",
		add_private = "Utente Specificato (di sotto):",
		address = "Indirizzo IP",
		mask   = "Netmask",
		gateway = "Gateway",
		dns1 = "DNS1",
		dns2 = "DNS2",
		dns3 = "DNS3",
		domain = "Domimnio",
		essid = "Nome Rete",
		psk = "Password WPA",
		country = "Area Geografica",
		int_down = "Disattiva Interfaccia",
		int_up = "Attiva Interfaccia",
		int_downup = "Disattiva Interfaccia / Attiva Interfaccia",
		none = "(nessuno)",
		address_tip = "Inserisci l'indirizzo IP statico",
		mask_tip = "Inserisci la maschera di Rete",
		gateway_tip = "Inserisci l' indirizzo del tuo router",
		dns1_tip = "Inserisci l' indirizzo del primo server DNS",
		dns2_tip = "Inserisci l' indirizzo del secondo server DNS (facoltativo)",
		dns3_tip = "Inserisci l' indirizzo del terzo server DNS (facoltativo)",
		domain_tip = "Inserisci il dominio DNS (facoltativo",
		essid_tip = "Inserisci il nome (SSID) della tua Rete",
		other_ssid_tip = "Inserisci l' SSID se il nome della tua Rete non compare",
		psk_tip = "Inserisci la password WPA",
		country_tip = "Inserisci la tua regione geografica per la rete senza fili",
		on_boot_tip = "Abilita questa interfaccia all' avvio",
		dhcp_tip = "Usa il servizio DHCP per ottenere informazioni relative al tuo indirizzo IP",
		error_address = "Indirizzo IP errato",
		error_gateway = "Gateway errato",
		error_netmask = "Maschera di Rete errata",
		error_dns1 = "DNS1 errato",
		error_dns2 = "DNS2 errato",
		error_dns3 = "DNS3 errato",
		error_static = "Indirizzo IP statico errato - Si prega di inserire Indirizzo IP, Maschera di Rete e Gateway",
		context =
		"<ul><li>Lo stato attuale dell' Interfaccia è visualizzato in cima alla pagina. Se non viene visualizzato un indirizzo IP, allora vuol dire che l' interfaccia non sta funzionando correttamente.</li>" ..
		"<li><i><b>All'&nbsp;Avvio</b></i> consente l' attivazione dell' interfaccia quando il dispositivo viene avviato.  Si prega di attivare questa opzione almeno per una interfaccia.</li>" ..
		"<li><i><b>DHCP</b></i> consente di ottenere un indirizzo IP direttamente dalla rete.  Si prega di deselezionare questa opzione se si desidera specificare un indirizzo IP statico.</li>" ..
		"<li><i><b>Salva</b></i> consente di salvare le mofiche apportate, mentre <i>Disattiva&nbsp;Interfaccia&nbsp;/&nbsp;Attiva&nbsp;Interfaccia</i> consente di riavviare l' interfaccia con i nuovi parametri inseriti.</li></ul>",
		context_wifi = "<ul><li>Per le reti senza fili è possibile selezionare quale rete utilizzare dalla lista <i>Nome&nbsp;Rete</i> trovate, altrimenti puoi specificare il nome della tua Rete nel caso in cui si tratti di una rete nascosta. Una password WPA deve essere inoltre specificata.  Si prega di notare che al momento l' unico metodo di autentificazione supportato è quello WPA/WPA2 con chiave pre-shared.</li></ul>",
		AT = "Austria",
		AU = "Australia",
		BE = "Belgio",
		CA = "Canada",
		CH = "Svizzera",
		CN = "Cina",
		DE = "Germania",
		DK = "Danimarca",
		ES = "Spagna",
		FI = "Finlandia",
		FR = "Francia",
		GB = "Gran Bretagna",
		HK = "Hong Kong",
		HU = "Ungheria",
		JP = "Giappone",
		IE = "Irlanda",
		IL = "Israele",
		IN = "India",
		IT = "Italia",
		NL = "Olanda",
		NO = "Norvegia",
		NZ = "New Zelanda",
		PL = "Polonia",
		PT = "Portogallo",
		RS = "Serbia",
		RU = "Federazione Russa",
		SE = "Svezia",
		US = "USA",
		ZA = "Sud Africa",
		['00'] = "Roaming",
	},
	['squeezelite'] = {
		title = "Configurazione e Controllo Squeezelite Player",
		name = "Nome",
		audio_output = "Uscita Audio",
		mac  = "Indirizzo MAC",
		device = "Dispositivo Audio",
		rate = "Campionamnento",
		logfile = "File di Log",
		loglevel = "Livello di Log",
		priority = "Prioritá thread RT",
		buffer = "Buffer",
		codec = "Codec",
		alsa = "Parametri Alsa",
		resample = "Ricampionamento",
		dop = "DoP",
		vis = "Visualiser", 
		other = "Altre Opzioni",
		server = "Indirizzo IP del Server",
		advanced = "Avanzate",
		bit_16 = "16 bit",
		bit_24 = "24 bit",
		bit_24_3 = "24_3 bit",
		bit_32 = "32 bit",
		mmap_off = "MMAP disattivo",
		mmap_on = "MMAP attivo",
		dop_supported = "Il Dispositivo supporta il DoP",
		name_tip = "Nome del Player (facoltativo)",
		device_tip = "Seleziona il dispositivo audio",
		alsa_buffer_tip = "Durata del buffer Alsa in ms oppure in bytes (facoltativo)",
		alsa_period_tip = "Conteggio del numero di periodi del buffer Alsa in bytes (facoltativo)",
		alsa_format_tip = "Formato della frequenza di campionamento Alsa (facoltativo)",
		alsa_mmap_tip = "Supporto del servizio MMAP (facoltativo)",
		rate_tip = "Massima frequenza supportata oppure lista di frequenze separate da una virgola (facoltativo)",
		rate_delay_tip = "Ritardo nel passaggio da una frequenza di campionamento ad un altra in ms (facoltativo)",
		dop_tip = "Abilita il DoP (DSD over PCM)",
		dop_delay_tip = "Ritardo nel passaggio tra PCM e DoP in ms (facoltativo)",
		advanced_tip = "Mostra opzioni avanzate",
		resample_tip = "Abilita il ricampionamento",
		vis_tip= "Abilita il visualizzatore (Visualiser) in Jivelite",
		resample_recipe = "Qualitá Sox",
		resample_options = "Opzioni Sox",
		very_high = "Molto alta",
		high = "Alta",
		medium = "Media",
		low = "Bassa",
		quick = "Rapida",
		linear = "Fase Lineare",
		intermediate = "Fase Intermedia",
		minimum = "Fase Minima",
		steep = "Filtro Steep",
		resample_options = "Opzioni Sox",
		flags = "Flag",
		attenuation = "Attenuazione",
		precision = "Precisione",
		pass_end = "Passa-Banda",
		stop_start = "Stoppa-Banda",
		phase = "Fase",
		async = "Asincrono",
		exception = "Eccezione",
		resample_quality_tip = "Alti valori della qualitá richiedono un maggiore uso del processore",
		resample_filter_tip = "Tipo di filtro di campionamneto",
		resample_steep_tip = "Usa il filtro Steep",
		resample_flags_tip = "Flag di ricampionamento (intero esadecimale), opzioni avanzate",
		resample_attenuation_tip = "Attenuazione in dB per evitare il clipping (valore di default pari a 1dB se non impostato diversamente)",
		resample_precision_tip = "Bit di precisione, (HQ = 20, VHQ = 28)",
		resample_end_tip = "Valore finale del filtro passa-banda in percentuale (Nyquist = 100%)",
		resample_start_tip = "Valore iniziale del filtro stoppa-banda in percentuale (deve essere maggiore di quello finale del filtro di passa-banda)",
		resample_phase_tip = "Risposta di fase (0 = minima, 50 = lineare, 100 = massima)",
		resample_async_tip = "Ricampiona in modo asincrono alla massima frequenza di campionamnerto (altrimenti ricampiona alla massima frequenza in modo sincrono)",
		resample_exception_tip = "Ricampiona solo quando la frequenza di campionamneto  non è supportata dal dispositivo di uscita",
		info = "Informazioni",
		debug = "Debug",
		trace = "Trace",
		loglevel_slimproto_tip = "Livello di log della sessione di controllo slimproto",
		loglevel_stream_tip = "Livello di log dello stream audio",
		loglevel_decode_tip = "Livello di log della decodifica",
		loglevel_output_tip = "Livello di log dell' uscita audio",
		logfile_tip = "Salva il debug in uno file specifico",
		buffer_stream_tip = "Dimensione del buffer di stream audio Kbytes (facoltativo)",
		buffer_output_tip = "Dimensione del buffer di uscita in Kbytes (facoltativo)",
		codec_tip = "Lista dei codec da caricare separati da una virgola (facoltativo - carica tutti i codec se nessun codec viene selezionato)",
		priority_tip = "Prioritá del thread RT (1-99) (facoltativo)",
		mac_tip = "Indirizzo MAC del Player, formato: ab:cd:ef:12:34:56 (facoltativo)",
 		server_tip = "Indirizzo IP del Server (facoltativo))",
		other_tip = "Altri parametri di configurazione facoltativi",
		error_alsa_buffer = "Errore di configurazione del Buffer Alsa",
		error_alsa_period = "Errore di configurazione del Periodo Alsa",
		error_rate = "Errore di configurazione della frequenza di campionamento",
		error_rate_delay = "Errore di configurazione del ritardo del cambio della frequenza di campionamento",
		error_dop_delay = "Errore di configurazione del ritardo del DoP",
		error_resample_precision = "Errore di configurazione della precisione del ricampionamento",
		error_resample_attenuation = "Errore di configurazione dell' attenuazione del ricampionamento",
		error_resample_start = "Errore di configurazione del valore iniziale del filtro stoppa-banda",
		error_resample_end = "Errore di configurazione del valore finale del filtro passa-banda",
		error_resample_endstart = "Errore di configurazione dei parametri del ricampionamento - il valore finale del passa-banda non dovrebbe sovrapporsi con quello iniziale dello stoppa-banda",
		error_resample_phase = "Errore di configurazione della risposta di fase del ricampionamento",
		error_buffer_stream = "Errore di configurazione della dimensione del buffer",
		error_buffer_output = "Errore di configurazione della dimensione del buffer di uscita",
		error_codec = "Errore di configurazione dei Codec",
		error_priority = "Errore di configurazione della prioritá del Thread RT",
		error_mac = "Errore di configurazione del' indirizzo MAC",
		error_server = "Errore di configurazione del Server",
		context = 
		"<ul><li>Il riquadro <i><b>Stato</b></i> in cima alla pagina mostra lo stato attuale dello Squeezelite Player che viene aggiornato premendo il pulsante <i>Aggiorna</i> . Il Player risulterá <i>attivo / in funzione</i> se tutto funziona correttamente. Altrimenti ricontrolla le opzioni di configurazione  e riavvia il Player.</li>" ..
		"<li>Le opzioni di configurazione possono essere specificate nei campi presenti sulla sinistra.  Dopo avere aggiornato tutti i campi premi il pulsante <i>Salva</i> per salvare le modifiche oppure <i>Salva&nbsp;e&nbsp;Riavvia</i> per salvare le modifiche e riavviare il Player con le nuove impostazioni.</li>" ..
		"<li><i><b>Nome</b></i> consente di specificare il nome del Player.  Se questo campo viene lasciato vuoto, puoi sempre impostarlo successivamente dal menú Squeeze Server.</i>" ..
		"<li><i><b>Dispositivo Audio</b></i> consente di specificare quale dispositivo di uscita audio utilizzare. Questo campo dovrebbe essere sempre specificato. Di norma è consigliato di selezionare i nomi dei dispositivi che cominciano con <i>hw:</i> per pilotare direttamente il dispositivo hardware.  Se uno o piú dispositivi sono presenti nella lista, provali tutti ad uno ad uno e riavvia ogni volta il Player fino a quando non trovi il corretto dispositivo per il tuo DAC.</li>" ..
		"<li><i><b>Parametri&nbsp;Alsa</b></i> consente di impostare in modo dettagliato tutti i parametri Alsa dell' uscita audio di Linux ma non sono necessari per il normale funzionamneto del dispositivo.  Modifica questi parametri solo se lo stato del Player indica che non sta funzionando oppure per ottimizzare il playback audio se si dovessero verificare delle perdite di suono. Sono presenti quattro parametri:" ..
		"<ul>" ..
		"<li><i>Durata (Alsa) del buffer</i> in ms, o <i>dimensione del buffer</i> in bytes; (default 40), imposta un valore piú alto se si dovessero verificare delle perdite di suono.</li>" ..
		"<li><i>Conteggio (Alsa) del periodo</i> o <i>dimensione del periodo</i> in bytes; (default 4).</li>" ..
		"<li><i>Formato (Alsa) della frequenza</i> rappresenta il numero di bit di dati inviati ad Alsa per ciascun campione - prova con il valore 16 se altri valori non dovessero funzionare.</li>" ..
		"<li><i>MMAP (Alsa)</i> consente di abilitare o disabilitare il servizio Alsa MMAP che riduce il carico della CPU, prova a disabilitarlo se il Player non dovessere funzionare.</li>" ..
		"</ul>" ..
		"<li><i><b>Campionamneto</b></i> consente di specificare le frequenze di campionamneto supportate dal dispositivo prima dell' avvio dello Squeezelite Player. Puoi o specificare una frequenza di campionamento <i>massima</i>, oppure specificare tutte le frequenze supportate separate da una virgola. Se il tuo DAC lo richiede, puoi anche specificare un ritardo in ms da aggiungere quando si cambia frequenza di campionamneto.</li>" ..
		"<li><i><b>DoP</b></i> consente di abilitare il playback DoP (DSP over PCM) per il tuo DAC. Puoi anche specificare un ritardo in ms quando si passa dalla modalitá PCM a quella DoP e viceversa.</li></ul>",
		context_resample = 
		"<p><ul><li><i><b>Ricampionamento</b></i> consente di abilitare il software di ricampionamento (upsampling) usando una libreria (SoX) ad alta qualitá di ricampionamento.  Di default l' audio viene ricampionato (upsampling) alla massima frequenza (di campionamento) sincrona supportata dal dispositivo di uscita audio.</li>" ..
		"<li>Selezionando <i><b>Asincrono</b></i> si ottiene sempre un ricampionamento alla massima frequenza di campionamneto dell' uscita audio.  Selezionando <i><b>Eccezione</b></i> si ottiene sempre un ricampionamento quando il dispositivo di uscita non supporta la frequenza di campionamento della traccia audio riprodotta.</li>" .. 
		"<li><i><b>Parametri&nbsp;Soxr</b></i> consente di specificare i parametri di base della libreria Soxr:" ..
		"<ul><li><i>Qualitá</i> consente di selezionare la qualitá del campionamneto. Si consiglia di impostare solo i valori di <i>Alta</i> (di default) oppure <i>Molto Alta</i> qualitá. Si prega di notare che alti valori di qualitá richiedono una maggiore potenza di elaborazione della CPU che aumenta con la frequenza di campionamento.</li>" ..
		"<li><i>Filtro</i> consente di selezionare la risposta di fase del filtro da utilizzare." ..
		"<li><i>Steep</i> consente di selezionare un filtro steep cut-off.</li></ul>"..
		"<li><i><b>Opzioni&nbsp;Soxr</b></i> consentono di impostare opzioni specifiche per un uso altamente avanzato:"..
		"<ul><li><i>Flag</i> consente di specificare le opzioni di flag della libreria Soxr in esadecimale (solo per utenti esperti).</li>"..
		"<li><i>Attenuazione</i> consente di specificare l' attenuazione in dB per evitare fenomeni di audio clipping nellla fase di campionamento (di default 1dB).</li>"..
		"<li><i>Passa-Banda</i> consente di specificare in percentuale il punto finale del filtro passa-banda; 100 è la frequenza di Nyquist.</li>"..
		"<li><i>Stoppa-Banda</i> consente di specificare in percentuale il punto iniziale del filtro stoppa-banda; 100 è la frequenza di Nyquist.</li>"..
		"<li><i>Risposta di fase</i> consente di specificare i valori della fase del filtro tra 0 e 100; 0 = fase minima, 25 = fase intermedia e 50 = fase lineare.</li>" ..
		"</ul>",
		context_advanced = 
		"<p><ul><li><i><b>Avanzate</b></i> contiene ulteriori opzioni che di norma non occorre modificare come il logging utilizzato per il debug di problemi.</li>" ..
		"<li>Configurazione <i><b>Livello&nbsp;Log</b></i> consente di impostare il livello di informazioni che vengono salvate nel file di log per ciascuna delle quattro categorie di logging, e che vengono mostrate nella finestra di log in fondo alla pagina. Clicca sulla finestra di log per avviare o arrestare ll' aggiornamento dela finestra di logel</b></i> .</li></ul>",
	},
	['squeezeserver'] = {
		title = "Controllo Squeeze Server",
		web_interface = "Interfaccia Web SqueezeServer",
		context =
		"<ul><li>Il riquadro <i><b>Stato</b></i> in cima alla pagina mostra lo stato attuale del Server  Squeezebox attivo sul tuo dispositivo.  Puó essere aggiornato premendo il pulsante <i>Aggiorna</i>. Il server puó essere abilitato, disabilitato e riavviato premendo i rispettivi pulsanti <i>Abilita</i>d, <i>Disabilita</i>d e <i>Riavvia</i>. Il server risulterá <i>attivo / in funzione</i> se tutto funziona correttamente.</li>" ..
		"<li>Non occorre abilitare lo SqueezeServer, se quest' ultimo risulta attivo su un' altra macchina.</li>" ..
		"<li>Usa il pulsante <i>Interfaccia&nbsp;Web&nbsp;SqueezeServer</i> per avviare una sessione web dello SqueezeServer attivo.</li></ul>",
	},
	['storage'] = {
		title = "Storage",
		mounts = "File Systems",
		localfs = "Disco Locale",
		remotefs = "Condivisione Rete",
		disk = "Disco",
		network = "Condivisione Rete",
		user = "Nome Utente",
		pass = "Password",
		domain = "Dominio",
		mountpoint = "Punto di Mount",
		type = "Tipo",
		options = "Opzioni",
		add = "Aggiungi",
		remove = "Elimina",
		unmount = "Smonta",
		remount = "Rimonta",
		active = "Attivo",
		inactive = "Inattivo",
		samba = "Server Samba",
		nb_name = "Nome Server Samba",
		nb_group = "Workgroup Samba",
		samba_ro = "(samba solo lettura)",
		samba_rw = "(samba scrittura)",
		export_ro = "condiviso dal Server Samba (solo lettura)",
		export_rw = "condiviso dal Server Samba (scrittura)",
		mountpoint_tip = "Locazione del punto di mount nel file di sistema del dispositivo",
		disk_tip = "Disco da montare",
		network_tip = "Disco/rete condivisi da montare",
		type_tip = "Tipo disco/rete condivisi da montare",
		user_tip = "Nome utente per il punto di mount CIFS",
		pass_tip = "Password per il punto di mount CIFS",
		domain_tip = "Dominio per il punto di mount CIFS (facolttivo)",
		options_tip = "Ulteriori opzioni di mount",
		samba_tip = "Abilita il server Samba",
		nb_name_tip = "Nome del Netbios per la condivione di file con Samba",
		nb_group_tip = "Nome del Workgroup per la condivisione di file con Samba",
		options_space = "Le opzioni di mount non devono includere spazi",
		context =
		"<ul><li>Da questo menú è possibile montare dischi fissi locali e remoti da utilizzare con lo Squeeze Server.</li>" ..
		"<li>Il riquadro <i><b>Disco&nbsp;Locale</b></i> è utilizzato per montare i dischi fissi locali. Seleziona una delle opzioni per specificare il punto di mount. Questo è il percorso dove apparirá il file system del dispositivo. Si prega di selezionare una delle opzioni per il disco da montare. Di norma non è necessario selezionare il tipo del disco dal momento che questo viene individuato automaticamente in base al suo formato.  Clicca sul pulsante <i>Aggiungi</i> per montare il disco. Se l' operazione va a buon fine dovresti vedere comparire una nuova voce nel riquadro dei <i>File&nbsp;Systems&nbsp;Montati</i> in cima alla pagina, altrimenti dovrebbe apparire un messaggio di errore. In presenza di partizioni multiple presenti sul disco potrebbe essere necessario provare ad una ad una le opzioni per ciascuna di esse fino a trovare quella corretta.</li>" ..
		"<li>Il riquadro <i><b>Condivisione&nbsp;Rete</b></i> consente di configurare la condivisione di files nella rete. Seleziona una delle opzioni per il punto di montaggio. Successivamente specifica la posizione e il tipo della condivisione di rete. Per la condivsione in Windows (Cifs) ti verranno richiesti nome utente, password e dominio. Potrebbe non essere necessarrio specificare tutti questi dettagli. Clicca sul pulsante <i>Aggiungi</i> per montare il disco di rete. Se l' operazione va a buon fine dovresti vedere comparire una nuova voce nel riquadro dei <i>File&nbsp;Systems&nbsp;Montati</i> in cima alla pagina, altrimenti dovrebbe apparire un messaggio di errore. Il campo Condivisione&nbsp;Rete dovrebbe deve essere popolato come segue:" ..
		"<ul><li><b>//MyNAS/Music</b> nel caso di una cartella condivisa windows col nome <i>Music</i> presente su un  NAS oppure un server col nome <i>MyNAS</i></li>" ..
		"<li><b>//192.168.1.100/Music</b> nel caso di una cartella condivisa windows col nome  <i>Music</i> presente su un NAS oppure un server con indirizzo IP <i>192.168.1.100</i></li>" ..
		"<li><b>Machine:/path</b> per una condivisione di tipo NFS con relativo <i>/path</i> presente su un NAS oppure un server col nome <i>Machine</i></li></ul>" ..
		"<li>I file systems, se connessi fisicamente al dispositivo, verranno montati automaticamente al successivo riavvio del sistema.  Per la loro disconnessione si prega di cliccare sul pulsante <i>Elimina</i> che si trova nel riquadro <i>File&nbsp;Systems&nbsp;Montati</i>.</li>" ..
		"<li>Se la tua libreria di file musicali contiene nomi di artisti, album o titoli con caratteri Unicode come accenti e dieresi, allora in questo caso dovresti aggiungere l' opzione <b>iocharset=utf8</b> nel relativo campo delle opzioni.</li>" ..
		"<li>Il riquadro <i><b>Server&nbsp;Samba</b></i> è utilizzato per configurare il file di configurazione di Samba direttamente dal tuo dispositivo.  Tutti i dischi locali o condivisioni di rete montati tramite questo menú, saranno disponibili come file di condivisione su altri dispositivi appartenenti alla tua rete.  Assegna un <i>Nome Server Samba</i> unico per la tua Rete e un nome per il  <i>Workgroup Samba</i> per combaciare con le altre impostazioni dei tuoi dispositivi.</li>" ..
		"</ul>",
	},
	['shutdown'] = {
		title = "Esci: Riavvia o arresta il sistema",
		control = "Controllo",
		halt = "Arresta",
		halt_desc = "Arresto del sistema. Attendere 30 secondi prima di scollegare il cavo di alimentazione.",
		reboot = "Riavvia",
		reboot_desc = "Riavvio del dispositivo.",
		context =
		"<ul><li>Da questo menú è possibile riavviare o arrestare il tuo dispositivo.</li>" ..
		"<li>Prima di scollegare il cavo di alimentazione si prega di attendere almeno 30 secondi perché il sistema si arresti.</li></ul>",
	},
	['reboothalt'] = {
		halting = "Arresto del sistema in corso - Prima di scollegare il cavo di alimentazione si prega di attendere almeno 30 secondi perché il sistema si arresti.",
		rebooting = "Riavvio del sistema",
	},
	['update'] = {
		title = "Aggiorna",
		installremove = "Installa/Rimuovi",
		squeezelite = "Squeezelite",
		server78 = "Squeeze Server 7.8",
		server79 = "Squeeze Server 7.9",
		jivelite = "Jivelite",
		kernel = "Aggiorna  Kernel",
		update = "Aggiorna",
		clean1 = "Aggiorna Parzialmente",
		clean2 = "Aggiorna Totalmente",
		update_desc = "Aggiorna il sistema e tutti i componenti installati",
		reinstall = "Reinstalla SoA",
		reinstall_desc = "Cancella e rimuovi completamente Squeeze on Arch",
		reinstall_check = "Cancella dispositivo e reinstalla completamente Squeese on Arch",
		context =
		"<ul><li>Utililizza questo menú per installare o rimuovere componenti facoltativi di Squeeze on Arch e per aggiornare i componenti già installati.</li>" ..
		"<li>Seleziona <i><b>Aggiorna</b></i> per aggiornare il sistema linux Arch e tutti i componenti Squeeze on Arch installati.  Questa operazione potrebbero richiedere  del tempo per essere eseguita.</li>" ..
                "<li>Seleziona <i><b>Aggiorna Parzialmente / Totalmente</b></i> per eliminare i file scaricati usati per il processo di aggiornamento del sistema. Questo consente di liberare spazio sul disco e potrebbe essere necessario qualora si verifichino errori durante il download dei file.  (L'aggiornamento parziale elimina meno file e dovrebbe essere utilizzato per primo.)</li>" ..
                "<li><i><b>Installa/Rimuovi</b></i> consente di aggiungere o rimuovere componenti facoltativi. Seleziona i componenti che desideri installare e poi premi il pulsante <i>Installa/Rimuovi</i>.  I componenti che possono essere installati sono:" ..
		"<ul><li>Squeezelite - applicazione necessaria per la riproduzione audio dal tuo dispositivo</li>" ..
		"<li>Jivelite - interfaccia HDMI per il tuo dispositivo</li>" ..
		"<li>Squeeze Server 7.8 - versione stabile di Logitech media server 7.8</li>"..
		"<li>Squeeze Server 7.9 - versione beta di Logitech media server 7.9 che implementa funzionalità sperimentali e che quindi potrebbe essere instabile.  Nota: è possibile installare solo una versione di Squeeze Server alla volta.</li>" ..
		"<li>Aggiorna Kernel - è un kernel linux aggiornato con funzionalità aggiuntive come il supporto audio spdif.</li>" ..
		"</ul>" ..
		"<li><i><b>Reinstalla SoA</b></i> consente di reinstallare completamente Squeeze on Arch cancellando il tuo dispositivo e riavviando il processo di installazione. Si prega di ricaricare la finestra del browser 30 secondi dopo l'inizio del processo di installazione.</li>" ..
		"<li>Informazioni sul progresso dell' installazione e degli aggiornamenti in corso vengono mostrati nel riquadro in basso.  Puoi arrestare o riavviare la schermata premendo sul riquadro.</li></ul>",
	},
	['header'] = {
		home = "Home",
		system = "Sistema",
		ethernet = "Interfaccia Rete Ethernet",
		wireless = "Interfaccia Rete Senza Fili",
		storage = "Storage",
		shutdown = "Esci",
		help = "Aiuto",
		squeezelite = "Squeezelite Player",
		squeezeserver = "Squeeze Server",
		update = "Aggiorna"
	},
	['footer'] = {
		copyright = "Copyright",
		version = "Versione",
		footer1 = "Interfaccia di Configurazione di Squeeze on Arch. Solo per uso non commerciale.",
		footer2 = "QUESTO SOFTWARE VIENE FORNITO COSI' COME E' SENZA ALCUNA GARANZIA ESPLICITA O IMPLICITA, COMPRESE, SENZA LIMITAZIONE, LE GARANZIE IMPLICITE DI COMMERCIABILITA' E IDONEITA' PER UN PARTICOLARE SCOPO. ",	},
	['base'] = { -- these are shared between all pages
		status = "Stato",
		active = "Attivo",
		service = "Servizio",
		refresh = "Aggiorna",
		enable  = "Abilita",
		disable = "Disabilita",
		restart = "Riavvia",
		reset   = "Cancella",
		save    = "Salva",
		save_restart = "Salva e Riavvia",
		configuration = "Configurazione",
		options = "Opzioni",
		help = "Aiuto",
	},
}

