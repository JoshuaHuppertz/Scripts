#!/usr/bin/env bash

# Function to check even_deny_root and root_unlock_time in faillock.conf
check_faillock_configuration() {
    grep -Pi -- '^\h*(even_deny_root|root_unlock_time\h*=\h*\d+)\b' /etc/security/faillock.conf
}

# Function to check root_unlock_time setting in faillock.conf
check_root_unlock_time() {
    grep -Pi -- '^\h*root_unlock_time\h*=\h*([1-9]|[1-5][0-9])\b' /etc/security/faillock.conf
}

# Function to check pam_faillock root_unlock_time in common-auth
check_pam_faillock_root_unlock_time() {
    grep -Pi -- '^\h*auth\h+([^#\n\r]+\h+)pam_faillock\.so\h+([^#\n\r]+\h+)?root_unlock_time\h*=\h*([1-9]|[1-5][0-9])\b' /etc/pam.d/common-auth
}

# Main script execution
echo "Starting audit for even_deny_root and root_unlock_time configuration..."

# Check even_deny_root and root_unlock_time setting in faillock.conf
faillock_output=$(check_faillock_configuration)

if [[ -n "$faillock_output" ]]; then
    echo -e "\n** PASS **"
    echo " - Found the following settings in /etc/security/faillock.conf:"
    echo "$faillock_output"
else
    echo -e "\n** FAIL **"
    echo " - No even_deny_root or root_unlock_time settings found in /etc/security/faillock.conf."
fi

# Check if root_unlock_time is set and is equal to 60 or more
root_unlock_time_output=$(check_root_unlock_time)

if [[ -z "$root_unlock_time_output" ]]; then
    echo -e "\n** PASS **"
    echo " - root_unlock_time is either not set or is set to a value less than 60."
else
    echo -e "\n** FAIL **"
    echo " - The following root_unlock_time setting was found:"
    echo "$root_unlock_time_output"
    echo " - This value should not be set or should be greater than 60."
fi

# Check pam_faillock for root_unlock_time settings
pam_faillock_output=$(check_pam_faillock_root_unlock_time)

if [[ -z "$pam_faillock_output" ]]; then
    echo -e "\n** PASS **"
    echo " - The pam_faillock configuration for root_unlock_time is correct."
else
    echo -e "\n** FAIL **"
    echo " - The following pam_faillock root_unlock_time setting was found:"
    echo "$pam_faillock_output"
    echo " - This value should not be set or should be greater than 60."
fi

# Final result
echo -e "\nAudit completed."
