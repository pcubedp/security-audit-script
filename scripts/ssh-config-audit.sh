#!/bin/bash
#SSH -> Secure Shell, sshd -> secure shell daemon

# =~ is the regex matching operator, used to compare a string to a regex pattern, gives way more filtering options comapred to directly searching strings.

#For checking if sshd is enabled or not
SSH_CONFIG="/etc/ssh/sshd_config"

echo "Checking SSH service status..."
if systemctl is-active --quiet sshd; then
    echo -e "\033[0;32mSSH service is running\033[0m"
else
    echo -e "\033[0;31mSSH service is not running\033[0m"
fi

# interating through each line the file, and checking for each parameter if its allowed or not, giving alert likewise
echo "Auditing SSH configuration..."
echo "-----------------------------------------------"

while IFS= read -r line; do
    if [[ "$line" =~ ^PermitRootLogin ]]; then
        if [[ "$line" == *"yes"* ]]; then
            echo -e "\033[0;31mWarning: Root login is allowed! Consider setting 'PermitRootLogin no'\033[0m"
        fi
    elif [[ "$line" =~ ^PasswordAuthentication ]]; then
        if [[ "$line" == *"yes"* ]]; then
            echo -e "\033[0;31mWarning: Password authentication is allowed! Consider setting 'PasswordAuthentication no'\033[0m"
        fi
    elif [[ "$line" =~ ^ChallengeResponseAuthentication ]]; then
        if [[ "$line" == *"yes"* ]]; then
            echo -e "\033[0;31mWarning: Challenge response authentication is allowed! Consider setting 'ChallengeResponseAuthentication no'\033[0m"
        fi
    elif [[ "$line" =~ ^UsePAM ]]; then
        if [[ "$line" == *"yes"* ]]; then
            echo -e "\033[0;31mWarning: PAM is enabled! Consider setting 'UsePAM no'\033[0m"
        fi
    elif [[ "$line" =~ ^PermitEmptyPasswords ]]; then
        if [[ "$line" == *"yes"* ]]; then
            echo -e "\033[0;31mWarning: Empty passwords are allowed! Consider setting 'PermitEmptyPasswords no'\033[0m"
        fi
    elif [[ "$line" =~ ^AllowTcpForwarding ]]; then
        if [[ "$line" == *"yes"* ]]; then
            echo -e "\033[0;31mWarning: TCP forwarding is allowed! Consider setting 'AllowTcpForwarding no'\033[0m"
        fi
    elif [[ "$line" =~ ^MaxAuthTries ]]; then
        if [[ "$line" == *"5"* ]]; then
            echo -e "\033[0;31mWarning: MaxAuthTries is high! Consider setting 'MaxAuthTries 3'\033[0m"
        fi
    elif [[ "$line" =~ ^LogLevel ]]; then
        if [[ "$line" != *"VERBOSE"* ]]; then
            echo -e "\033[0;31mWarning: LogLevel is not VERBOSE! Consider setting 'LogLevel VERBOSE'\033[0m"
        fi
    fi
done < "$SSH_CONFIG"

# for checkign if SSH key-based authentication is in use
echo "Checking SSH key-based authentication..."
if grep -q "AuthorizedKeysFile" "$SSH_CONFIG"; then
    echo -e "\033[0;32mSSH key-based authentication is configured\033[0m"
else
    echo -e "\033[0;31mSSH key-based authentication is NOT configured! Consider adding 'AuthorizedKeysFile' entry\033[0m"
fi

# checking for weak ciphers and protocols
echo "Checking for weak ciphers and protocols..."
CIPHERS=$(grep -i "Ciphers" "$SSH_CONFIG")
if [[ "$CIPHERS" =~ "arcfour" || "$CIPHERS" =~ "3des" || "$CIPHERS" =~ "blowfish" ]]; then
    echo -e "\033[0;31mWarning: Weak ciphers (e.g., arcfour, 3des, blowfish) are configured. Consider using stronger ciphers\033[0m"
else
    echo -e "\033[0;32mNo weak ciphers found\033[0m"
fi

PROTOCOLS=$(grep -i "Protocol" "$SSH_CONFIG")
if [[ "$PROTOCOLS" =~ "1" ]]; then
    echo -e "\033[0;31mWarning: SSHv1 is enabled! Consider setting 'Protocol 2'\033[0m"
else
    echo -e "\033[0;32mSSH Protocol 2 is being used\033[0m"
fi

echo "---------------------------------------"
echo "SSH Configuration Audit Completed"
