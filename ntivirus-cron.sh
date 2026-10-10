#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <dir> <malicious_dir>"
    exit 1
fi

MONITORED_DIR="$1"
MALICIOUS_DIR="$2"
WHITELIST_FILE="whitelist.txt"

touch "$WHITELIST_FILE"

echo "[+] Running scheduled cron antivirus scan on $MONITORED_DIR..."

for file in "$MONITORED_DIR"/*; do
    [ -f "$file" ] || continue
    
    filename=$(basename "$file")
    
    if grep -Fxq "$filename" "$WHITELIST_FILE"; then
        continue
    fi
    
    is_malicious=0

    case "$filename" in
        *.exe|*.bat|*.vbs|*.scr|*.ps1)
            is_malicious=1
            ;;
    esac

    if [ "$is_malicious" -eq 0 ]; then
        if grep -qiE "virus|trojan|malware|worm|ransomware" "$file"; then
            is_malicious=1
        fi
    fi

    if [ "$is_malicious" -eq 1 ]; then
        echo "$filename is malicious and it is DELETED"
        cp "$file" "$MALICIOUS_DIR/"
        rm "$file"[cite: 1]
    fi
done
