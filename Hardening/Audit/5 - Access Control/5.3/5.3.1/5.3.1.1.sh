#!/usr/bin/env bash

# Expected version of libpam-runtime (update this with the required version)
EXPECTED_VERSION="1.4.0-9"  # Change this to the required version

# Function to check the version of libpam-runtime
check_libpam_runtime_version() {
    dpkg_output=$(dpkg-query -s libpam-runtime | grep -P -- '^(Status|Version)\b')
    echo "$dpkg_output"
}

# Main script execution
echo "Starting audit for libpam-runtime version..."

# Check libpam-runtime version
version_output=$(check_libpam_runtime_version)

if [[ -n "$version_output" ]]; then
    # Extract the installed version
    installed_version=$(echo "$version_output" | grep "Version" | awk '{print $2}')

    echo -e "\nInstalled version: $installed_version"

    # Check if the installed version matches the expected version
    if [[ "$installed_version" == "$EXPECTED_VERSION" ]]; then
        echo -e "\n** PASS **"
        echo " - The installed version of libpam-runtime ($installed_version) matches the expected version ($EXPECTED_VERSION)."
    else
        echo -e "\n** FAIL **"
        echo " - The installed version of libpam-runtime ($installed_version) does not match the expected version ($EXPECTED_VERSION)."
    fi
else
    echo -e "\n** FAIL **"
    echo " - libpam-runtime is not installed or the query returned no results."
fi

# Final result
echo -e "\nAudit completed."
