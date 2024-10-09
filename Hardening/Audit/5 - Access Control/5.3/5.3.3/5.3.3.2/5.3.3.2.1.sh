#!/usr/bin/env bash

# Function to check if difok is set to 2 or more
check_difok_setting() {
    grep -Psi -- '^\h*difok\h*=\h*([2-9]|[1-9][0-9]+)\b' /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf
}

# Function to check if difok is incorrectly set to 0 or 1 in common-password
check_incorrect_difok() {
    grep -Psi -- '^\h*password\h+(requisite|required|sufficient)\h+pam_pwquality\.so\h+([^#\n\r]+\h+)?difok\h*=\h*([0-1])\b' /etc/pam.d/common-password
}

# Main script execution
echo "Starting audit for difok option in password quality configuration..."

# Check if difok is set to 2 or more
difok_output=$(check_difok_setting)

if [[ -n "$difok_output" ]]; then
    echo -e "\n** PASS **"
    echo " - Found the following difok setting(s):"
    echo "$difok_output"
else
    echo -e "\n** FAIL **"
    echo " - No valid difok setting found in /etc/security/pwquality.conf or /etc/security/pwquality.conf.d/*.conf."
fi

# Check if difok is incorrectly set to 0 or 1 in common-password
incorrect_difok_output=$(check_incorrect_difok)

if [[ -z "$incorrect_difok_output" ]]; then
    echo -e "\n** PASS **"
    echo " - No incorrect difok settings (0 or 1) found in /etc/pam.d/common-password."
else
    echo -e "\n** FAIL **"
    echo " - The following incorrect difok setting(s) found in /etc/pam.d/common-password:"
    echo "$incorrect_difok_output"
    echo " - difok should not be set to 0 or 1."
fi

# Final result
echo -e "\nAudit completed."
