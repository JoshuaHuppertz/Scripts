#!/usr/bin/env bash

# Function to check for strong password hashing algorithm in pam_unix.so module
check_strong_hashing_algorithm() {
    grep -PH -- '^\h*password\h+([^#\n\r]+)\h+pam_unix\.so\h+([^#\n\r]+\h+)?(sha512|yescrypt)\b' /etc/pam.d/common-password
}

# Main script execution
echo "Starting audit for strong password hashing algorithm on pam_unix.so module..."

# Check for strong hashing algorithms
hashing_output=$(check_strong_hashing_algorithm)

# Verify if the output contains a strong hashing algorithm
if [[ -n "$hashing_output" ]]; then
    echo -e "\n** PASS **"
    echo " - A strong password hashing algorithm is set on the pam_unix.so module:"
    echo "$hashing_output"
else
    echo -e "\n** FAIL **"
    echo " - A strong password hashing algorithm (sha512 or yescrypt) is NOT set on the pam_unix.so module."
fi

# Final result
echo -e "\nAudit completed."
