#!/usr/bin/env bash

# Function to check if enforce_for_root is enabled in pwquality configuration files
check_enforce_for_root() {
    grep -Psi -- '^\h*enforce_for_root\b' /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf
}

# Main script execution
echo "Starting audit for enforce_for_root configuration..."

# Check enforce_for_root settings in pwquality configuration files
enforce_for_root_output=$(check_enforce_for_root)

# Verify if enforce_for_root is enabled
if [[ -n "$enforce_for_root_output" ]]; then
    echo -e "\n** PASS **"
    echo " - The enforce_for_root option is enabled in the following configuration file(s):"
    echo "$enforce_for_root_output"
else
    echo -e "\n** FAIL **"
    echo " - The enforce_for_root option is not enabled in /etc/security/pwquality.conf or /etc/security/pwquality.conf.d/*.conf."
fi

# Final result
echo -e "\nAudit completed."
