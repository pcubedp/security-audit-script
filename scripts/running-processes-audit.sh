#!/bin/bash

# ps stands for "process status", gives info abt current running processes 
# -e -> shows all processes,   -o -> custom output format, --no-headers -> removes headers only data printed


# ---------- Color Definitions ----------
RED='\033[0;31m'      # High severity
YELLOW='\033[0;33m'   # Medium severity
GREEN='\033[0;32m'    # Low severity
BLUE='\033[0;34m'     # Info
RESET='\033[0m'       # Reset color



echo "-------------------- RUNNING PROCESSES AUDIT ---------------------"
ps -eo user,pid,tty,stat,cmd --no-headers | while read -r user poid tty stat cmd; do

    [[ -z "$cmd" ]] && continue
    #skip system/kernel processes if they are empty

    severity="${GREEN}LOW${RESET}"

    if [[ "$user" == "root" ]]; then
        if [[ "$cmd" == /tmp/* || "$cmd" == /home/* || "$cmd" == /dev/shm/* || "$cmd" == *\.sh || "$cmd" == *\.py || "$cmd" == *\.out ]]; then
            severity="${RED}High${RESET}"
        else
            severity="${YELLOW}Medium${RESET}"
        fi
    fi

    echo "User     : $user"
    echo "PID      : $pid"
    echo "TTY      : $tty"
    echo "Status   : $stat"
    echo "Command  : $cmd"
    echo -e "Severity : $severity"
    echo "-------------------------------------------------------"
done
