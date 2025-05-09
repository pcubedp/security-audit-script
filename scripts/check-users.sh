#!/bin/bash
#check-users.sh - list all users on the system
#/etc/passwd file structure -> username:password:UID:GID:User Info:Home Directory:Shell


echo "==================== USER & AUTHENTICATION AUDIT ====================="
echo

# List all users (Column 1 of /etc/passwd)
# /etc/passwd contains all user account info, I cut out the first field till the delimiter (:) for just the username
echo "[+] Listing all user accounts:"
cut -d: -f1 /etc/passwd
echo

#List human users with /bin/bash login
#$3 is the positional argument for UID, 65534 is a nobody account (system), 0 is root, >=1000 are generally human users
echo "[+] Human users with login shell:"
awk -F: '($3 >= 1000 || $3 == 0) && ($3 != 65534) {print $1}' /etc/passwd
echo

# Locked accounts
#^ ?! or * at the start of the password field means the account is disabled or locked.
#If the pattern matches, it prints the username, which is field $1.
echo "[+] Locked accounts:"
sudo awk -F: '($2 ~ /^[!*]/) {print $1}' /etc/shadow
echo


