#!/usr/bin/env bash

# Function to check dictcheck settings in the pwquality configuration files
check_dictcheck() {
    grep -Psi -- '^\h*dictcheck\h*=\h*0\b' /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf
}

# Function to check if dictcheck is disabled in common-password
check_overridden_settings() {
    grep -Psi -- '^\h*password\h+(requisite|required|sufficient)\h+pam_pwquality\.so\h+([^#\n\r]+\h+)?dictcheck\h*=\h*0\b' /etc/pam.d/common-password
}

# Main script execution
echo "Starting audit for dictcheck configuration..."

# Check dictcheck settings
dictcheck_output=$(check_dictcheck)

# Verify if dictcheck is set to 0
if [[ -n "$dictcheck_output" ]]; then
    echo -e "\n** FAIL **"
    echo " - The dictcheck option is set to 0 (disabled) in the following configuration file(s):"
    echo "$dictcheck_output"
else
    echo -e "\n** PASS **"
    echo " - No dictcheck settings found that are set to 0 (disabled) in /etc/security/pwquality.conf or /etc/security/pwquality.conf.d/*.conf."
fi

# Check if dictcheck is overridden in common-password
overridden_output=$(check_overridden_settings)

if [[ -z "$overridden_output" ]]; then
    echo -e "\n** PASS **"
    echo " - No dictcheck settings found that are set to 0 (disabled) in /etc/pam.d/common-password."
else
    echo -e "\n** FAIL **"
    echo " - The following dictcheck settings found in /etc/pam.d/common-password are set to 0 (disabled):"
    echo "$overridden_output"
fi

# Final result
echo -e "\nAudit completed."
