#!/bin/bash

# / means it starts looking from root i.e. the whole filesystem, xdev is to avoid crossing into mounted filesystems
# -0002 is perms where others write bit is set (o+w)
#

RED='\033[0;31m'    # Red (High)
YELLOW='\033[0;33m' # Yellow (Medium)
GREEN='\033[0;32m'  # Green (Low)
RESET='\033[0m'     # Reset color


find / -type f -perm -0002 2>/dev/null | head -n 20 | while read line; do

    # Parse file details from output of ls -l
    filepath="$line"
    permissions=$(ls -l "$line" | awk '{print $1}')
    owner=$(ls -l "$line" | awk '{print $3}')
    group=$(ls -l "$line" | awk '{print $4}')

    # Severity determination
    if [[ "$owner" == "root" ]]; then
        severity="${RED}High${RESET}"
    elif [[ "$filepath" == /tmp/* ]]; then
        severity="${GREEN}Low${RESET}"
    else
        severity="${YELLOW}Medium${RESET}"
    fi

    # Print file details and severity
    echo "File: $filepath"
    echo "Permissions: $permissions"
    echo "Owner: $owner"
    echo "Group: $group"
    echo -e  "Severity: $severity"
    echo "-----------------------------------"
done 
