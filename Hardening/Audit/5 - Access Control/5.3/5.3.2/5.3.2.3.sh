#!/usr/bin/env bash

# Function to check for pam_pwquality in the common-password PAM configuration file
check_pam_pwquality_enabled() {
    grep -P -- '\bpam_pwquality\.so\b' /etc/pam.d/common-password
}

# Main script execution
echo "Starting audit for pam_pwquality configuration..."

# Check pam_pwquality entries
pam_pwquality_output=$(check_pam_pwquality_enabled)

if [[ -n "$pam_pwquality_output" ]]; then
    echo -e "\n** PASS **"
    echo " - pam_pwquality is enabled with the following configuration:"
    echo "$pam_pwquality_output"
else
    echo -e "\n** FAIL **"
    echo " - pam_pwquality is not enabled in the PAM configuration file."
fi

# Final result
echo -e "\nAudit completed."
