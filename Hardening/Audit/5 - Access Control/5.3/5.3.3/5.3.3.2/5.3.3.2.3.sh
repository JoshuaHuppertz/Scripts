#!/usr/bin/env bash

# Function to check password complexity settings
check_password_complexity() {
    grep -Psi -- '^\h*(minclass|[dulo]credit)\b' /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf
}

# Function to check if module arguments are being overridden in common-password
check_overridden_settings() {
    grep -Psi -- '^\h*password\h+(requisite|required|sufficient)\h+pam_pwquality\.so\h+([^#\n\r]+\h+)?(minclass=\d*|[dulo]credit=-?\d*)\b' /etc/pam.d/common-password
}

# Main script execution
echo "Starting audit for password complexity configuration..."

# Check password complexity settings
complexity_output=$(check_password_complexity)

# Check if settings for dcredit, ucredit, lcredit, ocredit are valid
if [[ -n "$complexity_output" ]]; then
    echo -e "\n** PASS **"
    echo " - Found the following password complexity settings:"
    echo "$complexity_output"

    # Validate values for dcredit, ucredit, lcredit, ocredit
    if echo "$complexity_output" | grep -qP '^[^\n]*[dulo]credit\s*=\s*[0-9]'; then
        echo -e "\n** FAIL **"
        echo " - One or more complexity settings (dcredit, ucredit, lcredit, ocredit) are set to a value greater than 0."
    else
        echo -e "\n** PASS **"
        echo " - All complexity settings are set to an acceptable value (not greater than 0)."
    fi
else
    echo -e "\n** FAIL **"
    echo " - No password complexity settings found in /etc/security/pwquality.conf or /etc/security/pwquality.conf.d/*.conf."
fi

# Check if module arguments are being overridden in common-password
overridden_output=$(check_overridden_settings)

if [[ -z "$overridden_output" ]]; then
    echo -e "\n** PASS **"
    echo " - No overridden complexity settings found in /etc/pam.d/common-password."
else
    echo -e "\n** FAIL **"
    echo " - The following overridden settings found in /etc/pam.d/common-password:"
    echo "$overridden_output"
    echo " - Module arguments should not override the complexity settings."
fi

# Final result
echo -e "\nAudit completed."
