#!/usr/bin/env bash

# Function to check for pam_unix in PAM configuration files
check_pam_unix_enabled() {
    grep -P -- '\bpam_unix\.so\b' /etc/pam.d/common-{account,session,auth,password}
}

# Main script execution
echo "Starting audit for pam_unix configuration..."

# Check pam_unix entries
pam_unix_output=$(check_pam_unix_enabled)

if [[ -n "$pam_unix_output" ]]; then
    echo -e "\n** PASS **"
    echo " - pam_unix is enabled with the following configuration:"
    echo "$pam_unix_output"
else
    echo -e "\n** FAIL **"
    echo " - pam_unix is not enabled in the PAM configuration files."
fi

# Final result
echo -e "\nAudit completed."
