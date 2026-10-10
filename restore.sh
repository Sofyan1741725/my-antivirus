#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <dir> <malicious_dir>"
    exit 1
fi

MONITORED_DIR="$1"
MALICIOUS_DIR="$2"
WHITELIST_FILE="whitelist.txt"

touch "$WHITELIST_FILE"

while true; do
    files=("$MALICIOUS_DIR"/*)
    if [ ! -e "${files[0]}" ]; then
        echo "No malicious files to review."[cite: 1]
        break
    fi

    echo "=============================="
    echo "Quarantined Files List:"
    echo "=============================="

    i=1
    declare -A file_map
    for file in "${files[@]}"; do
        [ -f "$file" ] || continue
        filename=$(basename "$file")
        echo "$i) $filename"
        file_map[$i]="$filename"
        i=$((i + 1))
    done

    if [ ${#file_map[@]} -eq 0 ]; then
        echo "No malicious files to review."[cite: 1]
        break
    fi

    echo ""
    read -p "Pick a file by number (or type 0 to exit): " choice

    if [ "$choice" -eq 0 ]; then
        echo "Exiting restore tool."
        break
    fi

    selected_filename="${file_map[$choice]}"
    if [ -z "$selected_filename" ]; then
        echo "Invalid choice. Try again."
        continue
    fi

    full_path="$MALICIOUS_DIR/$selected_filename"

    echo ""
    echo "Selected file: $selected_filename"
    echo "1) Restore this file back into dir (it was a false positive)"[cite: 1]
    echo "2) Permanently delete this file from malicious_dir (it was genuinely malicious)"[cite: 1]
    echo "3) Leave this file as-is and go back to the list"[cite: 1]
    read -p "Enter your option (1-3): " option

    case "$option" in
        1)
            mv "$full_path" "$MONITORED_DIR/"
            echo "$selected_filename" >> "$WHITELIST_FILE"
            echo "Restored $selected_filename to $MONITORED_DIR."[cite: 1]
            ;;
        2)
            rm "$full_path"
            echo "$selected_filename permanently deleted."[cite: 1]            ;;
        3)
            echo "Leaving file as-is."
            ;;
        *)
            echo "Invalid option. Returning to list."
            ;;
    esac
    echo ""
done
