function backup_ncftp --description 'FTP biztonsági mentés készítése és feltöltése'
    # ========================
    # Berus FTP Backup Function (fish)
    # ========================

    # --- Konfiguráció ---
    set FTP_HOST "192.168.0.8"      # A távoli FTP szerver címe
    set FTP_USER "berus"            # FTP felhasználónév
    set FTP_PASS "usergb"           # FTP jelszó
    set FTP_DIR "/berus/BKP"        # A távoli könyvtár, ahova mentünk

    set LOCAL_DIR "/home/berus/Adatok/dotfiles"  # A helyi könyvtár, amit menteni szeretnénk
    set BACKUP_NAME "dots_(date +%Y%m%d_%H%M%S).tar.gz"  # A mentés fájlneve időbélyeggel

    set LOG_FILE "/home/berus/.local/log/ftp_backup.log"  # Naplófájl

    # --- Segédfüggvény ---
    function log
        set msg $argv[1]
        echo (date "+%Y-%m-%d %H:%M:%S")" - $msg" | tee -a $LOG_FILE
    end

    # --- Fő folyamat ---
    log "INFO: Mentési folyamat elindítva."

    # Ellenőrizzük, hogy létezik-e a helyi könyvtár
    if not test -d $LOCAL_DIR
        log "HIBA: A helyi könyvtár nem létezik: $LOCAL_DIR"
        return 1
    end

    # Archívum létrehozása
    log "INFO: Archívum létrehozása: $BACKUP_NAME"
    tar -czf /tmp/$BACKUP_NAME -C $LOCAL_DIR .

    if test $status -ne 0
        log "HIBA: Az archívum létrehozása sikertelen."
        rm -f /tmp/$BACKUP_NAME 2>/dev/null
        return 1
    end

    # Feltöltés FTP-re
    log "INFO: Feltöltés az FTP szerverre: $FTP_HOST"
    ncftpput -u $FTP_USER -p $FTP_PASS -P 21 $FTP_HOST $FTP_DIR /tmp/$BACKUP_NAME

    if test $status -eq 0
        log "RENDBEN: A biztonsági mentés sikeresen feltöltve: $BACKUP_NAME"
        rm -f /tmp/$BACKUP_NAME
    else
        log "HIBA: A feltöltés sikertelen az FTP szerverre."
        return 1
    end

    log "INFO: Mentési folyamat befejezve."
end

