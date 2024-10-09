#!/usr/bin/env bash

# Function to check the use_authtok argument in pwhistory configuration
check_use_authtok() {
    grep -Psi -- '^\h*password\h+[^#\n\r]+\h+pam_pwhistory\.so\h+([^#\n\r]+\h+)?use_authtok\b' /etc/pam.d/common-password
}

# Main script execution
echo "Starting audit for use_authtok configuration..."

# Check use_authtok settings in common-password
use_authtok_output=$(check_use_authtok)

# Verify if the output contains the expected use_authtok setting
if [[ -n "$use_authtok_output" ]]; then
    echo -e "\n** PASS **"
    echo " - The use_authtok argument is correctly configured in the pwhistory line:"
    echo "$use_authtok_output"
else
    echo -e "\n** FAIL **"
    echo " - The use_authtok argument is missing in the pwhistory line of /etc/pam.d/common-password."
fi

# Final result
echo -e "\nAudit completed."
