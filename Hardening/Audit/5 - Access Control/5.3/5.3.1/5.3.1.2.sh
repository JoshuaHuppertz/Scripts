#!/usr/bin/env bash

# Minimum required version of libpam-modules
MINIMUM_VERSION="1.5.2-6"

# Function to check the status and version of libpam-modules
check_libpam_modules_version() {
    dpkg_output=$(dpkg-query -s libpam-modules | grep -P -- '^(Status|Version)\b')
    echo "$dpkg_output"
}

# Main script execution
echo "Starting audit for libpam-modules version..."

# Check libpam-modules version
version_output=$(check_libpam_modules_version)

if [[ -n "$version_output" ]]; then
    # Extract the installed version
    installed_version=$(echo "$version_output" | grep "Version" | awk '{print $2}')

    echo -e "\nInstalled version: $installed_version"

    # Compare the installed version with the minimum required version
    if dpkg --compare-versions "$installed_version" ge "$MINIMUM_VERSION"; then
        echo -e "\n** PASS **"
        echo " - The installed version of libpam-modules ($installed_version) is equal to or later than the minimum required version ($MINIMUM_VERSION)."
    else
        echo -e "\n** FAIL **"
        echo " - The installed version of libpam-modules ($installed_version) is older than the minimum required version ($MINIMUM_VERSION)."
    fi
else
    echo -e "\n** FAIL **"
    echo " - libpam-modules is not installed or the query returned no results."
fi

# Final result
echo -e "\nAudit completed."
