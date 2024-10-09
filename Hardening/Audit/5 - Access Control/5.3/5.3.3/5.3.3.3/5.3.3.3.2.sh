#!/usr/bin/env bash

# Function to check the enforce_for_root argument in pwhistory configuration
check_enforce_for_root() {
    grep -Psi -- '^\h*password\h+[^#\n\r]+\h+pam_pwhistory\.so\h+([^#\n\r]+\h+)?enforce_for_root\b' /etc/pam.d/common-password
}

# Main script execution
echo "Starting audit for enforce_for_root configuration..."

# Check enforce_for_root settings in common-password
enforce_for_root_output=$(check_enforce_for_root)

# Verify if the output contains the expected enforce_for_root setting
if [[ -n "$enforce_for_root_output" ]]; then
    echo -e "\n** PASS **"
    echo " - The enforce_for_root argument is correctly configured in the pwhistory line:"
    echo "$enforce_for_root_output"
else
    echo -e "\n** FAIL **"
    echo " - The enforce_for_root argument is missing in the pwhistory line of /etc/pam.d/common-password."
fi

# Final result
echo -e "\nAudit completed."
