#!/usr/bin/env bash

# Function to check for pam_faillock in PAM configuration files
check_pam_faillock_enabled() {
    grep -P -- '\bpam_faillock\.so\b' /etc/pam.d/common-{auth,account}
}

# Main script execution
echo "Starting audit for pam_faillock configuration..."

# Check pam_faillock entries
pam_faillock_output=$(check_pam_faillock_enabled)

if [[ -n "$pam_faillock_output" ]]; then
    echo -e "\n** PASS **"
    echo " - pam_faillock is enabled with the following configuration:"
    echo "$pam_faillock_output"
else
    echo -e "\n** FAIL **"
    echo " - pam_faillock is not enabled in the PAM configuration files."
fi

# Final result
echo -e "\nAudit completed."
