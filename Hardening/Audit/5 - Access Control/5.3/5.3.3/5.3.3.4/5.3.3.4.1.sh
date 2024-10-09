#!/usr/bin/env bash

# Function to check for nullok argument in pam_unix.so module
check_nullok_argument() {
    grep -PH -- '^\h*[^#\n\r]+\h+pam_unix\.so\b' /etc/pam.d/common-{password,auth,account,session,session-noninteractive} | grep -Pv -- '\bnullok\b'
}

# Main script execution
echo "Starting audit for nullok argument in pam_unix.so module..."

# Check nullok settings in PAM configuration files
nullok_output=$(check_nullok_argument)

# Verify if the output is empty (indicating nullok is not set)
if [[ -n "$nullok_output" ]]; then
    echo -e "\n** PASS **"
    echo " - The nullok argument is not set on the pam_unix.so module in the following configurations:"
    echo "$nullok_output"
else
    echo -e "\n** FAIL **"
    echo " - The nullok argument is set on the pam_unix.so module in one or more configurations."
fi

# Final result
echo -e "\nAudit completed."
