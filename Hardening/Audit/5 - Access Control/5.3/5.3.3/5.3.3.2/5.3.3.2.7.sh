#!/usr/bin/env bash

# Function to check enforcing settings in the pwquality configuration files
check_enforcing_in_pwquality() {
    grep -PHsi -- '^\h*enforcing\h*=\h*0\b' /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf
}

# Function to check if enforcing is disabled in common-password
check_enforcing_in_pam() {
    grep -PHsi -- '^\h*password\h+[^#\n\r]+\h+pam_pwquality\.so\h+([^#\n\r]+\h+)?enforcing=0\b' /etc/pam.d/common-password
}

# Main script execution
echo "Starting audit for enforcing configuration..."

# Check enforcing settings in pwquality configuration files
enforcing_pwquality_output=$(check_enforcing_in_pwquality)

# Verify if enforcing is set to 0
if [[ -n "$enforcing_pwquality_output" ]]; then
    echo -e "\n** FAIL **"
    echo " - The enforcing option is set to 0 in the following configuration file(s):"
    echo "$enforcing_pwquality_output"
else
    echo -e "\n** PASS **"
    echo " - No enforcing settings found that are set to 0 in /etc/security/pwquality.conf or /etc/security/pwquality.conf.d/*.conf."
fi

# Check if enforcing is overridden in common-password
enforcing_pam_output=$(check_enforcing_in_pam)

if [[ -z "$enforcing_pam_output" ]]; then
    echo -e "\n** PASS **"
    echo " - No enforcing settings found that are set to 0 in /etc/pam.d/common-password."
else
    echo -e "\n** FAIL **"
    echo " - The following enforcing settings found in /etc/pam.d/common-password are set to 0:"
    echo "$enforcing_pam_output"
fi

# Final result
echo -e "\nAudit completed."
