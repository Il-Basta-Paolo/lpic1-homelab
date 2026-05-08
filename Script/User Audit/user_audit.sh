#!/bin/bash

# ==============================================================================
# Script: user_audit.sh
# Descrizione: Genera un report degli utenti fisici del sistema con shell interattiva,
#              escludendo i demoni e gli account di servizio.
# Autore: Paolo Basta
# Data: Maggio 2026
# ==============================================================================

# Definizione del target
TARGET_FILE="/etc/passwd"

# 1. Error Handling: Controllo di pre-volo
# Verifica che il file esista e che l'utente corrente abbia i permessi di lettura
if [[ ! -r "$TARGET_FILE" ]]; then
    echo "ERRORE CRITICO: Il file $TARGET_FILE non esiste o non è leggibile." >&2
    exit 1
fi

# 2. Motore di Estrazione AWK
# Utilizziamo AWK per formattare e filtrare i record
awk -F':' '
  # Blocco di inizializzazione: Stampa l'\''Header
  BEGIN {
      print "========================================="
      print "         AUDIT UTENTI DI SISTEMA         "
      print "========================================="
      print "Account attivi con Shell di Login:"
      print "-----------------------------------------"
  }
  
  # Condizione e Azione: Cerca shell valide e stampa lo username
  $7 ~ /sh$/ {
      print " -> " $1
  }
  
  # Blocco di chiusura: Stampa il Footer
  END {
      print "========================================="
      print "              FINE REPORT                "
      print "========================================="
  }
' "$TARGET_FILE" > ./user_audit_report.txt
echo "Il report è pronto nella cartella corrente."

# 3. Uscita pulita
# Segnala al sistema operativo che l'esecuzione ha avuto successo
exit 0