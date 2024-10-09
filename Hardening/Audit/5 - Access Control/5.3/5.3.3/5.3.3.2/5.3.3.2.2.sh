#!/usr/bin/env bash

# Function to check if minlen is set to 14 or more
check_minlen_setting() {
    grep -Psi -- '^\h*minlen\h*=\h*(1[4-9]|[2-9][0-9]|[1-9][0-9]{2,})\b' /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf
}

# Function to check if minlen is incorrectly set to less than 14 in common-password or system-auth
check_incorrect_minlen() {
    grep -Psi -- '^\h*password\h+(requisite|required|sufficient)\h+pam_pwquality\.so\h+([^#\n\r]+\h+)?minlen\h*=\h*([0-9]|1[0-3])\b' /etc/pam.d/system-auth /etc/pam.d/common-password
}

# Main script execution
echo "Starting audit for minimum password length (minlen) configuration..."

# Check if minlen is set to 14 or more
minlen_output=$(check_minlen_setting)

if [[ -n "$minlen_output" ]]; then
    echo -e "\n** PASS **"
    echo " - Found the following valid minlen setting(s):"
    echo "$minlen_output"
else
    echo -e "\n** FAIL **"
    echo " - No valid minlen setting found in /etc/security/pwquality.conf or /etc/security/pwquality.conf.d/*.conf."
fi

# Check if minlen is incorrectly set to less than 14 in common-password or system-auth
incorrect_minlen_output=$(check_incorrect_minlen)

if [[ -z "$incorrect_minlen_output" ]]; then
    echo -e "\n** PASS **"
    echo " - No incorrect minlen settings (less than 14) found in /etc/pam.d/system-auth or /etc/pam.d/common-password."
else
    echo -e "\n** FAIL **"
    echo " - The following incorrect minlen setting(s) found in /etc/pam.d/system-auth or /etc/pam.d/common-password:"
    echo "$incorrect_minlen_output"
    echo " - minlen should not be set to less than 14."
fi

# Final result
echo -e "\nAudit completed."
