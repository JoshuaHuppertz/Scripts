#!/usr/bin/env bash

# Function to check maxsequence settings in the pwquality configuration files
check_maxsequence() {
    grep -Psi -- '^\h*maxsequence\h*=\h*[1-3]\b' /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf
}

# Function to check if maxsequence is overridden in common-password
check_overridden_settings() {
    grep -Psi -- '^\h*password\h+(requisite|required|sufficient)\h+pam_pwquality\.so\h+([^#\n\r]+\h+)?maxsequence\h*=\h*(0|[4-9]|[1-9][0-9]+)\b' /etc/pam.d/common-password
}

# Main script execution
echo "Starting audit for maxsequence configuration..."

# Check maxsequence settings
maxsequence_output=$(check_maxsequence)

# Check if settings for maxsequence are valid
if [[ -n "$maxsequence_output" ]]; then
    echo -e "\n** PASS **"
    echo " - Found the following maxsequence settings:"
    echo "$maxsequence_output"

    # Validate values for maxsequence
    if echo "$maxsequence_output" | grep -qP '^[^\n]*maxsequence\s*=\s*0\b'; then
        echo -e "\n** FAIL **"
        echo " - The maxsequence option is set to 0, which is not allowed."
    elif echo "$maxsequence_output" | grep -qP '^[^\n]*maxsequence\s*=\s*[4-9]\b'; then
        echo -e "\n** FAIL **"
        echo " - The maxsequence option is set to a value greater than 3."
    else
        echo -e "\n** PASS **"
        echo " - The maxsequence option is set to a valid value (3 or less)."
    fi
else
    echo -e "\n** FAIL **"
    echo " - No maxsequence settings found in /etc/security/pwquality.conf or /etc/security/pwquality.conf.d/*.conf."
fi

# Check if maxsequence is overridden in common-password
overridden_output=$(check_overridden_settings)

if [[ -z "$overridden_output" ]]; then
    echo -e "\n** PASS **"
    echo " - No overridden maxsequence settings found in /etc/pam.d/common-password."
else
    echo -e "\n** FAIL **"
    echo " - The following overridden settings found in /etc/pam.d/common-password:"
    echo "$overridden_output"
    echo " - The maxsequence option should not be set to 0 or greater than 3."
fi

# Final result
echo -e "\nAudit completed."
