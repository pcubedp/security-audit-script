#!/bin/bash


#Author: Parth Patel





# Color Codes
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RESET='\033[0m'

# Audit Script Directory
SCRIPT_DIR="./"

# Display Menu
echo -e "${CYAN}--------- LINUX SECURITY AUDIT TOOL ---------${RESET}"
echo "Select an option:"
echo "1. Run ALL audits"
echo "2. Password Policy Audit"
echo "3. User Accounts Audit"
echo "4. World Writable Files Audit"
echo "5. SUID/SGID Files Audit"
echo "6. Open Ports & Listening Services Audit"
echo "7. Running Processes Audit"
echo "8. Cron Jobs Audit"
echo "9. SSH Configuration Audit"
echo "0. Exit"
echo -n "Enter your choice: "
read choice

run_all() {
    bash "$SCRIPT_DIR/check-password-policy.sh"
    bash "$SCRIPT_DIR/check-users.sh"
    bash "$SCRIPT_DIR/world-writable-files.sh"
    bash "$SCRIPT_DIR/suid-sgid-audit.sh"
    bash "$SCRIPT_DIR/open-ports-ls.sh"
    bash "$SCRIPT_DIR/running-processes-audit.sh"
    bash "$SCRIPT_DIR/cron-jobs-audit.sh"
    bash "$SCRIPT_DIR/ssh-config-audit.sh"
}

case $choice in
    1) run_all ;;
    2) bash "$SCRIPT_DIR/check-password-policy.sh" ;;
    3) bash "$SCRIPT_DIR/check-users.sh" ;;
    4) bash "$SCRIPT_DIR/world-writable-files.sh" ;;
    5) bash "$SCRIPT_DIR/suid-sgid-audit.sh" ;;
    6) bash "$SCRIPT_DIR/open-ports-ls.sh" ;;
    7) bash "$SCRIPT_DIR/running-processes-audit.sh" ;;
    8) bash "$SCRIPT_DIR/cron-jobs-audit.sh" ;;
    9) bash "$SCRIPT_DIR/ssh-config-audit.sh" ;;
    0) echo "Exiting..."; exit 0 ;;
    *) echo "Invalid choice." ;;
esac

