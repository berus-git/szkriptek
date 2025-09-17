#!/bin/bash

# =========================
# Berus FTP Backup Szkript
# =========================

# --- Konfiguráció ---
FTP_HOST=" "          # A távoli FTP szerver címe
FTP_USER=" "          # FTP felhasználónév
FTP_PASS=" "          # FTP jelszó
FTP_DIR=" "           # A távoli könyvtár, ahova mentünk (léteznie kell!)

LOCAL_DIR=" "         # A helyi könyvtár, amit menteni szeretnénk
BACKUP_NAME="dots_$(date +%Y%m%d_%H%M%S).tar.gz"  # A mentés fájlneve (időbélyeggel)

LOG_FILE="/var/log/ftp_backup.log"  # Naplófájl

# --- Függvények ---
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

# --- Főprogram ---
log "INFO: Mentési folyamat elindítva."

# Ellenőrizzük, hogy létezik-e a helyi könyvtár
if [ ! -d "$LOCAL_DIR" ]; then
    log "HIBA: A helyi könyvtár nem létezik: $LOCAL_DIR"
    exit 1
fi

# Archívum létrehozása (tömörítve)
log "INFO: Archívum létrehozása: $BACKUP_NAME"
tar -czf "/tmp/$BACKUP_NAME" -C "$LOCAL_DIR" .

if [ $? -ne 0 ]; then
    log "HIBA: Az archívum létrehozása sikertelen."
    rm -f "/tmp/$BACKUP_NAME" 2>/dev/null
    exit 1
fi

# Feltöltés az FTP szerverre
log "INFO: Feltöltés az FTP szerverre: $FTP_HOST"
ncftpput -u "$FTP_USER" -p "$FTP_PASS" -P 21 "$FTP_HOST" "$FTP_DIR" "/tmp/$BACKUP_NAME"

# Ellenőrizzük a feltöltés eredményét
if [ $? -eq 0 ]; then
    log "RENDBEN: A biztonsági mentés sikeresen feltöltve: $BACKUP_NAME"
    # Sikeres feltöltés után töröljük a helyi ideiglenes fájlt
    rm -f "/tmp/$BACKUP_NAME"
else
    log "HIBA: A feltöltés sikertelen az FTP szerverre."
    exit 1
fi

log "INFO: Mentési folyamat befejezve."
exit 0
