#!/bin/bash

echo "--------------------- CRON JOB AUDIT---------------------"
echo

#system-wide crontab
echo "System-wide crontab:"
cat /etc/crontab
echo "-----------------------------------"

#cron jobs for each user (/var/spool/cron/crontabs)
echo "User-specific cron jobs:"
for user in $(cut -f1 -d: /etc/passwd); do
    echo "Checking cron jobs for user: $user"
    crontab -u $user -l 2>/dev/null
done


echo "-----------------------------------"

echo "System cron jobs (cron.* directories):"
for dir in /etc/cron.*; do
    if [ -d "$dir" ]; then
        echo "Checking jobs in: $dir"
        ls -l $dir
    fi
done
echo "-----------------------------------"

# Check for suspicious cron jobs (Example: Running from /tmp, or unknown scripts)
echo "Checking for suspicious cron jobs..."
grep -E "(/tmp|/dev|/bin/bash)" /etc/crontab /var/spool/cron/crontabs/* /etc/cron.*/*

echo "-----------------------------------"
echo "Cron job audit completed."
       
                                                                  
                           
