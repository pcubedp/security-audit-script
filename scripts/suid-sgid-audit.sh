#!/bin/bash

#SUID/SGID Audit

echo "[+] SUID/SGID Audit:"
echo "-----------------------------------"

# SUID/SGID are special permission bits, these bits affect how perms are granted when a file is executed
# SUID -> Set User ID : any user running a file with this bit set executes it with perms of the file owner.
# SGID -> Set Group ID : any user running a file with this bit set executes it with perms of the file's group.
# Audit is necessary, cuz if a vulnerable executable has SUID/SGID, attackers may exploit it to,                                 1) escalate previleges to root     2) gain unautharized access to sensitive files.


# Search for files with SUID Or SGID Set and output results
# The find command searches for files starting from / and finds files that have either the SUID or SGID bit set. It uses the -perm flag to specify these permissions: -4000 -> SUID bit, -2000 -> SGID bit.
# here / means to look from root i.e. entire filesystem, -type f means to search for regular files only

RED='\033[0;31m'    # Red (High)
YELLOW='\033[0;33m' # Yellow (Medium)
GREEN='\033[0;32m'  # Green (Low)
RESET='\033[0m'     # Reset color

#f-> files
#d-> directory
#l-> symbolic link
#s-> Socket
#b-> block device
#c-> character device

#exec works with find command, it is to execute a command on the find's result, ls -l is long format we know, {} is placeholder
#/dev/null is a blackhole file, anything sent here is discarded
#2> redirects stder (standard error), so basically we are redirecting all error messages to null file to get discarded, to avoid error flood

# $NF is a special variable in awk which means the last field(positional argument) in a line, there are too many more such vars.

find / -type f \( -perm -4000 -o -perm -2000 \) -exec ls -l {} \; 2>/dev/null | while read line; do
    # Parse file details from out of ls -l 

    filepath=$(echo $line | awk '{print $NF}')
    permissions=$(echo $line | awk '{print $1}')
    owner=$(echo $line | awk '{print $3}')
    group=$(echo $line | awk '{print $4}')

    #Determining Severity
    case "$filepath" in 
        "/usr/bin/pkexec"|"/usr/bin/sudo"|"/usr/lib/dbus-daemon-launch-helper"|"/usr/bin/ksu")
            severity="${RED}High${RESET}";;
        "/usr/bin/passwd"|"/usr/bin/mount"|"/usr/bin/chage"|"/usr/bin/mount.cifs"|"/usr/bin/umount")
            severity="${YELLOW}Medium${RESET}" ;;
        *)
            severity="${GREEN}Low${RESET}" ;;
    esac     


    #and finally I am printing in readable format
    echo "File: $filepath"
    echo "Permissions: $permissions"
    echo "Owner: $owner"
    echo "Group: $group"
    echo -e "Severity: $severity"
    echo "-----------------------------------"

done
                                 
