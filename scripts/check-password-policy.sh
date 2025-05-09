#!/bin/bash
# check-password-policy.sh - Audits password expiration policies

echo "==================== PASSWORD POLICY AUDIT ====================="

# Print system-wide password aging policies
# grep used to search line that match a pattern
# -E flag lets us use things like parantheses() and pipes |
# grep checks and matches for specified stuff like PASS_MAX_DAYS In our case, once matched it returns whole line with it
echo "[+] System-wide password aging policy from:"
grep -E 'PASS_MAX_DAYS|PASS_MIN_DAYS|PASS_WARN_AGE' /etc/login.defs
echo

# Header for user-specific password aging info
# -15s - here (s) -> string, 15 -> characters padding length, (-) -> left-aligned, without (-) its default right align.
# echo and printf both can be used for text display but printf gives more formatting options and echo for simple stuff.
echo "[+] Password aging info for users:"
printf "%-15s %-20s %-5s %-5s %-5s\n" "User" "Last Change" "Min" "Max" "Warn"
echo "--------------------------------------------------------------"

# For each human user
# again using positional arguments, (:) our specified delimiter [see check-users.sh for /etc/passwd structure :) ]
# first line is just there to consider ONLY human users from UID, piped into a while loop
# chage command -> displays info abt password aging for a given user, -l for long format
# xargs -> used to remove any leading\trailing spaces in output

awk -F: '($3 >= 1000 || $3 == 0) && $3 != 65534 {print $1}' /etc/passwd | while read user; do
    last_change=$(chage -l "$user" | grep "Last password change" | cut -d: -f2 | xargs)
    min_days=$(chage -l "$user" | grep "Minimum number of days" | cut -d: -f2 | xargs)
    max_days=$(chage -l "$user" | grep "Maximum number of days" | cut -d: -f2 | xargs)
    warn_days=$(chage -l "$user" | grep "Number of days of warning" | cut -d: -f2 | xargs)

    printf "%-15s %-20s %-5s %-5s %-5s\n" "$user" "$last_change" "$min_days" "$max_days" "$warn_days"
done

