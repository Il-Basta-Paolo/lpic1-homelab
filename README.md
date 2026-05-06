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
* **I/O Streams e Piping:** Salvataggio permanente dell'output tramite l'operatore di ridirezione `>`(sovrascrive il file) e `>>` e concatenazione dei comandi tramite pipe `|` (es. `ls -la | less`) per gestire flussi di dati complessi.
