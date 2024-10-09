#!/usr/bin/env bash

# Function to check the deny setting in faillock.conf
check_faillock_deny_setting() {
    grep -Pi -- '^\h*deny\h*=\h*[1-5]\b' /etc/security/faillock.conf
}

# Function to check pam_faillock configuration in common-auth
check_pam_faillock_setting() {
    grep -Pi -- '^\h*auth\h+(requisite|required|sufficient)\h+pam_faillock\.so\h+([^#\n\r]+\h+)?deny\h*=\h*(0|[6-9]|[1-9][0-9]+)\b' /etc/pam.d/common-auth
}

# Main script execution
echo "Starting audit for failed logon attempts configuration..."

# Check deny setting in faillock.conf
faillock_deny_output=$(check_faillock_deny_setting)

if [[ -n "$faillock_deny_output" ]]; then
    echo -e "\n** PASS **"
    echo " - The deny setting is configured correctly:"
    echo "$faillock_deny_output"
else
    echo -e "\n** FAIL **"
    echo " - The deny setting in /etc/security/faillock.conf is not configured correctly or not found."
    echo " - Expected configuration: deny = [1-5]"
fi

# Check pam_faillock setting in common-auth
pam_faillock_output=$(check_pam_faillock_setting)

if [[ -z "$pam_faillock_output" ]]; then
    echo -e "\n** PASS **"
    echo " - The pam_faillock configuration is correct and denies setting is within acceptable limits."
else
    echo -e "\n** FAIL **"
    echo " - The pam_faillock configuration allows deny settings greater than 5:"
    echo "$pam_faillock_output"
fi

# Final result
echo -e "\nAudit completed."
