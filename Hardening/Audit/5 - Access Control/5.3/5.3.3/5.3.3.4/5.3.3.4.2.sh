#!/usr/bin/env bash

# Function to check for remember argument in pam_unix.so module
check_remember_argument() {
    grep -PH -- '^\h*[^#\n\r]+\h+pam_unix\.so\b' /etc/pam.d/common-{password,auth,account,session,session-noninteractive} | grep -Pv -- '\bremember=\d+\b'
}

# Main script execution
echo "Starting audit for remember argument in pam_unix.so module..."

# Check remember settings in PAM configuration files
remember_output=$(check_remember_argument)

# Verify if the output is empty (indicating remember is not set)
if [[ -n "$remember_output" ]]; then
    echo -e "\n** PASS **"
    echo " - The remember argument is not set on the pam_unix.so module in the following configurations:"
    echo "$remember_output"
else
    echo -e "\n** FAIL **"
    echo " - The remember argument is set on the pam_unix.so module in one or more configurations."
fi

# Final result
echo -e "\nAudit completed."
