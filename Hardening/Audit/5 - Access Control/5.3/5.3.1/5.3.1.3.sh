#!/usr/bin/env bash

# Function to check the status and version of libpam-pwquality
check_libpam_pwquality_installed() {
    dpkg_output=$(dpkg-query -s libpam-pwquality | grep -P -- '^(Status|Version)\b')
    echo "$dpkg_output"
}

# Main script execution
echo "Starting audit for libpam-pwquality installation..."

# Check libpam-pwquality installation
version_output=$(check_libpam_pwquality_installed)

if [[ -n "$version_output" ]]; then
    # Extract the installed version
    installed_version=$(echo "$version_output" | grep "Version" | awk '{print $2}')
    
    echo -e "\nInstalled version: $installed_version"

    # Output the status of the package
    status_output=$(echo "$version_output" | grep "Status")
    echo -e "$status_output"

    # Check if the status indicates it is installed
    if [[ $status_output == *"install ok installed"* ]]; then
        echo -e "\n** PASS **"
        echo " - libpam-pwquality is installed with version $installed_version."
    else
        echo -e "\n** FAIL **"
        echo " - libpam-pwquality is installed but not in a proper state: $status_output."
    fi
else
    echo -e "\n** FAIL **"
    echo " - libpam-pwquality is not installed."
fi

# Final result
echo -e "\nAudit completed."
