# LPIC-1 & Cloud Engineering - Homelab Journey

Questo repository documenta il mio piano di studio pratico e intensivo di 3 anni per diventare un Sistemista Linux, partendo dalle basi della certificazione LPIC-1 (Esame 101) per arrivare al Cloud e Kubernetes.

## Giorno 1: Setup dell'Ambiente di Laboratorio (Homelab)

Oggi ho configurato le fondamenta del mio ambiente di test. Ho optato per una virtualizzazione locale per avere un ambiente isolato e sicuro in cui sperimentare.

### Specifiche dell'Infrastruttura
* **Hypervisor:** VirtualBox (Tipo 2)
* **Macchina Virtuale:** `debian-server-01`
* **OS Guest:** Debian GNU/Linux (Versione Netinst)
* **Risorse Allocate:** 2048 MB RAM, 20 GB Disco VDI ad allocazione dinamica

### Scelte Architetturali
* **Interfaccia a Riga di Comando (CLI):** Durante l'installazione ho rimosso volontariamente i pacchetti relativi al Desktop Environment (GNOME, ecc.).
* **Accesso Remoto:** Ho abilitato il server SSH fin dalla fase di installazione per preparare la macchina all'amministrazione remota (headless).

### Pratica da Riga di Comando (CLI)
Durante la prima sessione, ho consolidato l'uso dei comandi fondamentali per la *situational awareness* e la navigazione del Filesystem Hierarchy Standard (FHS):
* **Identificazione e Navigazione:** Utilizzo di `whoami`, `pwd`, `uname -a`.
* **Gestione FHS:** Esplorazione della root `/`, della directory delle configurazioni globali `/etc` e delle directory utente in `/home`.

### Gestione Utenti e Permessi
Ho implementato la gestione base della sicurezza multi-utente di Linux, requisito fondamentale per l'esame LPIC-1:
* **Privilege Escalation:** Passaggio all'utente amministratore (root) tramite il comando `su -` per caricare l'ambiente corretto.
* **Creazione Utenti:** Provisioning di un nuovo utente standard con directory home associata tramite `useradd -m` e assegnazione sicura delle credenziali con `passwd`.
* **Manipolazione Permessi (Modalità Ottale):** Applicazione della matrice dei permessi (UGO/RWX). Ho utilizzato `touch` per creare un file di test e il comando `chmod 750` per assegnare permessi di lettura/scrittura/esecuzione al proprietario, lettura/esecuzione al gruppo, e nessun accesso per gli altri utenti (equivalente alla stringa `-rwxr-x---`).

### Manipolazione del Testo e Stream Redirection
Nella fase finale della sessione, mi sono concentrato sugli strumenti di analisi dei log e sulla gestione degli stream di I/O, competenze essenziali per il troubleshooting:
* **Analisi dei file:** Utilizzo di `cat` per output immediati e `less` come paginatore per l'ispezione di file lunghi (es. file di configurazione in `/etc`).
* **Filtraggio:** Ricerca di pattern specifici e identificazione dell'UID 0 tramite `grep` applicato al file `/etc/passwd`.
* **I/O Streams e Piping:** Salvataggio permanente dell'output tramite l'operatore di ridirezione `>`(sovrascrive il file) e `>>`(scrive in fondo, fa "append") e concatenazione dei comandi tramite pipe `|` (es. `ls -la | less`) per gestire flussi di dati complessi.

## Giorno 2: Gestione Pacchetti, Archiviazione, Processi e Bash Scripting Difensivo

Oggi ho ampliato le mie competenze nell'amministrazione di sistema, passando dai comandi base alla gestione avanzata del software, delle risorse e dell'automazione tramite script professionali.

### Gestione Pacchetti (APT) e Modularità
Ho analizzato i meccanismi di aggiornamento nei sistemi Debian-based, distinguendo tra la sincronizzazione dei metadati e l'installazione dei binari:
* **Sincronizzazione Indici:** Utilizzo di `apt update` per scaricare i metadati più recenti dai repository (file come `Packages` e `InRelease`) aggiornando il database locale senza alterare il software installato.
* **Aggiornamento Binari:** Utilizzo di `apt upgrade` per risolvere le dipendenze, scaricare e installare effettivamente i pacchetti `.deb` aggiornati basandosi sugli indici locali.
* **Modularità dei Repository:** Analisi della differenza tra il file monolitico `/etc/apt/sources.list` e l'approccio modulare della directory `/etc/apt/sources.list.d/`, essenziale per aggiungere sorgenti di terze parti in modo sicuro e automatizzabile.
* **Automazione delle Installazioni:** Installazione non interattiva di tool di monitoraggio e navigazione tramite l'opzione "yes", utilizzando il comando `sudo apt-get install htop tree -y`.

### Archiviazione e Compressione dei Dati
Ho implementato un backup completo della directory di configurazione di sistema (`/etc`), garantendo la conservazione dei permessi e prevenendo sovrascritture accidentali durante il ripristino:
* **Tarball e Gzip:** Comprensione della differenza sostanziale tra `tar` (creazione dell'archivio monolitico preservando permessi, proprietari e gerarchia FHS) e `gzip` (compressione dello stream di dati). Ho combinato i due strumenti in una singola operazione con il comando `sudo tar -czf backup_config.tar.gz /etc`.
* **Sicurezza dei Percorsi Assoluti:** Osservazione del comportamento protettivo di `tar`, che rimuove automaticamente lo slash iniziale (`/`) dai percorsi assoluti (es. da `/etc/passwd` a `etc/passwd`). Questo trasforma i percorsi in relativi, proteggendo la radice del sistema host in fase di scompattazione.

### Gestione e Monitoraggio dei Processi
Ho consolidato le tecniche di *process control* e la diagnostica delle risorse di sistema:
* **Identificazione (PID) e Memoria (RSS):** Analisi del *Process IDentifier* (con focus sul PID 1, l'init system vitale per il Kernel) e del *Resident Set Size*, ovvero la porzione di RAM fisica non-swappata attualmente allocata a un processo.
* **Gestione dei Segnali (Signals):** Differenziazione tra `SIGTERM` (15) per inviare una richiesta di chiusura *graceful* (pulita) e `SIGKILL` (9) per un *hard kill* sommario eseguito dal Kernel. Ho inoltre analizzato la natura dei processi "Zombie", impossibili da terminare direttamente poiché già "morti" in attesa di essere letti dal processo padre.
* **Job Control:** Esecuzione di processi in background (non bloccanti per la shell) aggiungendo l'operatore `&` a fine comando (es. `sleep 1000 &`) e loro ripristino in foreground tramite il comando `fg`.

### Auditing di Sicurezza e I/O Redirection
Ho strutturato un comando di auditing per scovare file con permessi critici, gestendo in modo esplicito i flussi standard di Unix:
* **Ricerca basata sui Metadati:** Utilizzo di `find` in contrapposizione a `grep` (che analizza il testo interno) per ispezionare l'albero del filesystem partendo dalla root (`/`). Ho applicato il filtro `-perm 777` per identificare file con permessi totali (lettura, scrittura ed esecuzione globale).
* **Isolamento dello Standard Error:** Gestione avanzata dei flussi di Input/Output. Per non inquinare i risultati validi (*Standard Output*, canale 1), ho reindirizzato esplicitamente gli errori "Permission denied" (*Standard Error*, canale 2) verso il dispositivo nullo di Linux, utilizzando `2> /dev/null`.

### Scripting Bash Difensivo e Sicurezza dell'Esecuzione
Ho convertito il comando singolo di audit in uno script bash professionale, robusto e riutilizzabile:
* **Shebang:** Utilizzo della direttiva `#!/bin/bash` alla riga 1 per indicare esplicitamente al Kernel l'interprete da utilizzare.
* **Variabile PATH e Sicurezza:** Comprensione del motivo per cui si usa `./` per eseguire script locali. La directory corrente (`.`) è intenzionalmente esclusa dalla variabile d'ambiente `$PATH` per prevenire l'esecuzione accidentale di script malevoli mascherati da comandi legittimi.
* **Controllo Privilegi (EUID):** Implementazione di un blocco logico di sicurezza basato sulla variabile `$EUID` (*Effective User ID*). Questo garantisce che lo script possa essere eseguito esclusivamente dall'utente root (UID 0), evitando audit parziali e fuorvianti.
* Caricamento del file dello script creato chiamato audit.sh

## Giorno 3: Architettura di Boot, Manipolazione Flussi e Auditing Dati Strutturati

Oggi ho approfondito il ciclo di vita del sistema operativo Linux e l'uso di strumenti non interattivi per l'analisi e la trasformazione dei dati, competenze chiave per l'automazione della sicurezza.

### Architettura del Processo di Boot
Ho analizzato la sequenza di transizioni di stato che intercorrono tra l'accensione fisica e il prompt utente:
* **Hardware Initiation (BIOS/UEFI):** Il firmware esegue il POST e localizza il bootloader nel MBR o nella partizione ESP.
* **Bootloader (GRUB2) e initrd:** Caricamento in RAM del Kernel compresso (`vmlinuz`) e dell'Initial Ramdisk (`initrd`). Ho appreso che l'`initrd` è significativamente più grande del Kernel poiché contiene un file system temporaneo completo di moduli e driver necessari per montare la root reale (`/`).
* **Kernel e Init System:** Inizializzazione dell'hardware, smontaggio dell'initrd e generazione del PID 1 (`systemd`), il processo padre responsabile dell'orchestrazione dei servizi nello User Space tramite le *target units*.

### Espressioni Regolari e Filtraggio Chirurgo (Grep)
Ho abbandonato la ricerca testuale semplice per passare all'estrazione basata su pattern (Regex), essenziale per il parsing dei file di sistema:
* **Ancoraggi di Riga (`^` e `$`):** Utilizzo dei metacaratteri per vincolare il match. L'ancoraggio di fine riga (`$`) in `grep "/bin/bash$"` garantisce l'isolamento della shell esatta, scartando varianti o directory simili. L'ancoraggio di inizio (`^sys:`) previene l'estrazione di falsi positivi.
* **Matching Flessibile:** Utilizzo del punto (`.`) come metacarattere per rappresentare un singolo carattere qualsiasi, permettendo la creazione di pattern di ricerca elastici ma precisi.

### Manipolazione dei Flussi in RAM (sed)
Ho esplorato `sed` (Stream Editor), distinguendolo dagli editor interattivi per la sua capacità di elaborare dati "on the fly":
* **Pattern Space:** Analisi del funzionamento di `sed`, che manipola i flussi di dati in transito (Standard Input) in un'area di memoria temporanea riga per riga, senza alterare i file fisici (salvo l'uso del flag `-i`).
* **Estrazione Silenziosa e Flag:** Implementazione del pattern `-n` con il comando `p` per stampare solo le righe che soddisfano determinati criteri di sostituzione o ricerca, riducendo drasticamente il "rumore" negli output di logging.

### Analisi e Parsing di Dati Strutturati (AWK)
Ho iniziato a utilizzare AWK come motore di reportistica, trattando i file di testo come database tabellari:
* **Variabili Architetturali:** Gestione del *Field Separator* (`-F`) per file delimitati (es. `:` in `/etc/passwd`) e dell'Output Field Separator (`OFS`) per formattare i risultati tramite la virgola `,` nell'istruzione `print`.
* **Filtraggio Condizionale e Regex (`~`):** Implementazione di controlli logici sui campi. Ho utilizzato l'operatore di match (`~`) per valutare un campo specifico contro un'espressione regolare (es. `$7 ~ /sh$/` per isolare solo shell interattive valide).
* **Architettura a Blocchi:** Utilizzo dei blocchi `BEGIN` (setup e header) ed `END` (footer e totali) per incapsulare il main loop di elaborazione in un report leggibile.

### Automazione e Scripting: user_audit.sh
Ho unito le tecnologie apprese in uno script Bash finalizzato all'auditing automatizzato:
* **Sviluppo dell'Auditor:** Creazione di uno script che estrae gli utenti fisici reali, ignorando sistematicamente i servizi e i demoni di sistema.
* **Redirezione e I/O Management:** Utilizzo della redirezione standard (`>`) per dirottare l'output formattato verso un file di report (`user_audit_report.txt`), separando la logica di generazione dalla visualizzazione.
* **Best Practice di Scripting:** Implementazione di feedback visivi tramite `echo` per l'operatore di sistema.
