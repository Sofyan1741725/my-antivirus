#!/bin/bash

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <dir> <malicious_dir> <interval-secs>"
    exit 1
fi

MONITORED_DIR="$1"
MALICIOUS_DIR="$2"
INTERVAL="$3"

LAST_INFO="directory-info.last"
NEW_INFO="directory-info.new"
WHITELIST_FILE="whitelist.txt"

touch "$WHITELIST_FILE"

scan_directory() {
    echo "[+] Scanning $MONITORED_DIR for malicious files..."
    
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
            cp "$file" "$MALICiyah_DIR/" 2>/dev/null || cp "$file" "$MALICIOUS_DIR/"
            rm "$file"
        fi
    done
}

if [ ! -f "$LAST_INFO" ]; then
    ls -1 "$MONITORED_DIR" > "$LAST_INFO"
    scan_directory
fi

while true; do
    sleep "$INTERVAL"
    
    ls -1 "$MONITORED_DIR" > "$NEW_INFO"
    
    if ! diff -q "$LAST_INFO" "$NEW_INFO" > /dev/null; then
        scan_directory
        cp "$NEW_INFO" "$LAST_INFO"
    else
        cp "$NEW_INFO" "$LAST_INFO"
    fi
done
