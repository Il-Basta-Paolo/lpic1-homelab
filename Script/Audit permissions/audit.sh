#!/bin/bash

# ==========================================
# Script di Audit Sicurezza: File con permessi 777
# Autore: Paolo Basta
# ==========================================

# 1. Controllo dei privilegi (Protezione contro i falsi positivi)
if [ "$EUID" -ne 0 ]; then
  echo "[-] Errore Critico: Questo script esegue un audit globale e richiede privilegi di root."
  echo "[-] Riavvia lo script utilizzando: sudo $0"
  exit 1
fi

# 2. Definisco le variabili
TARGET_DIR="/"
TARGET_PERM="777"
REPORT_FILE="/tmp/audit_report_$(date +%F).txt"

# 3. Feedback iniziale per l'utente
echo "=========================================="
echo " Avvio Audit di Sicurezza Sistema"
echo "=========================================="
echo "[*] Directory di partenza: $TARGET_DIR"
echo "[*] Permessi ricercati: $TARGET_PERM"
echo "[*] Generazione report in corso, attendere..."

# 4. Esecuzione del comando core
find "$TARGET_DIR" -type f -perm "$TARGET_PERM" > "$REPORT_FILE" 2> /dev/null

# 5. Feedback finale
echo "[+] Audit completato con successo."
echo "[+] I risultati sono stati salvati in: $REPORT_FILE"
echo "=========================================="