#!/usr/bin/env bash

# Function to check the unlock_time setting in faillock.conf
check_faillock_unlock_time() {
    grep -Pi -- '^\h*unlock_time\h*=\h*(0|9[0-9][0-9]|[1-9][0-9]{3,})\b' /etc/security/faillock.conf
}

# Function to check pam_faillock unlock_time in common-auth
check_pam_faillock_setting() {
    grep -Pi -- '^\h*auth\h+(requisite|required|sufficient)\h+pam_faillock\.so\h+([^#\n\r]+\h+)?unlock_time\h*=\h*([1-9]|[1-9][0-9]|[1-8][0-9][0-9])\b' /etc/pam.d/common-auth
}

# Main script execution
echo "Starting audit for account unlock time configuration..."

# Check unlock_time setting in faillock.conf
faillock_unlock_output=$(check_faillock_unlock_time)

if [[ -n "$faillock_unlock_output" ]]; then
    echo -e "\n** PASS **"
    echo " - The unlock_time setting is configured correctly:"
    echo "$faillock_unlock_output"
else
    echo -e "\n** FAIL **"
    echo " - The unlock_time setting in /etc/security/faillock.conf is not configured correctly or not found."
    echo " - Expected configuration: unlock_time = 0 or unlock_time = 900 (15 minutes) or more"
fi

# Check pam_faillock unlock_time setting in common-auth
pam_faillock_output=$(check_pam_faillock_setting)

if [[ -z "$pam_faillock_output" ]]; then
    echo -e "\n** PASS **"
    echo " - The pam_faillock configuration is correct and unlock_time setting is within acceptable limits."
else
    echo -e "\n** FAIL **"
    echo " - The pam_faillock configuration allows unlock_time settings that do not meet the requirements:"
    echo "$pam_faillock_output"
fi

# Final result
echo -e "\nAudit completed."
