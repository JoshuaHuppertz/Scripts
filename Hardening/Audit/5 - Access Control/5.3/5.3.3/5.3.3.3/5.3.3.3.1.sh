#!/usr/bin/env bash

# Function to check the pwhistory configuration
check_pwhistory() {
    grep -Psi -- '^\h*password\h+[^#\n\r]+\h+pam_pwhistory\.so\h+([^#\n\r]+\h+)?remember=\d+\b' /etc/pam.d/common-password
}

# Main script execution
echo "Starting audit for pwhistory configuration..."

# Check pwhistory settings in common-password
pwhistory_output=$(check_pwhistory)

# Verify if the output contains the expected remember=N setting
if [[ -n "$pwhistory_output" ]]; then
    # Extract the value of N
    N_value=$(echo "$pwhistory_output" | grep -oP 'remember=\K\d+')

    # Check if N is 24 or more
    if (( N_value >= 24 )); then
        echo -e "\n** PASS **"
        echo " - The pwhistory line is correctly configured with remember=${N_value} in /etc/pam.d/common-password:"
        echo "$pwhistory_output"
    else
        echo -e "\n** FAIL **"
        echo " - The remember value (${N_value}) is less than 24 in /etc/pam.d/common-password."
    fi
else
    echo -e "\n** FAIL **"
    echo " - The pwhistory line is missing or incorrectly configured in /etc/pam.d/common-password."
fi

# Final result
echo -e "\nAudit completed."
