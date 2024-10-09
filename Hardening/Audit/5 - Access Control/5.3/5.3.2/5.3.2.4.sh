#!/usr/bin/env bash

# Function to check for pam_pwhistory in the common-password PAM configuration file
check_pam_pwhistory_enabled() {
    grep -P -- '\bpam_pwhistory\.so\b' /etc/pam.d/common-password
}

# Main script execution
echo "Starting audit for pam_pwhistory configuration..."

# Check pam_pwhistory entries
pam_pwhistory_output=$(check_pam_pwhistory_enabled)

# Define the expected output for comparison
expected_output="password requisite pam_pwhistory.so remember=24 enforce_for_root try_first_pass use_authtok"

if [[ "$pam_pwhistory_output" == *"$expected_output"* ]]; then
    echo -e "\n** PASS **"
    echo " - pam_pwhistory is enabled with the following configuration:"
    echo "$pam_pwhistory_output"
else
    echo -e "\n** FAIL **"
    echo " - pam_pwhistory is not enabled or is misconfigured in the PAM configuration file."
    echo " - Expected configuration:"
    echo "$expected_output"
    echo " - Actual configuration found:"
    echo "$pam_pwhistory_output"
fi

# Final result
echo -e "\nAudit completed."
