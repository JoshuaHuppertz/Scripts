#!/usr/bin/env bash

# Function to check if a package is installed
check_package_installed() {
    local package_name="$1"
    
    # Check if the package is installed
    if dpkg-query -s "$package_name" &>/dev/null; then
        echo "$package_name is installed"
        return 0  # Package is installed
    else
        return 1  # Package is not installed
    fi
}

# Main script execution
echo "Starting audit for sudo and sudo-ldap installation..."

# Initialize audit result
audit_result="** FAIL **"

# Check for sudo
if check_package_installed "sudo"; then
    audit_result="** PASS **"
    echo -e "\n- Audit Result:\n$audit_result\n - sudo is installed."
else
    # Check for sudo-ldap if sudo is not installed
    if check_package_installed "sudo-ldap"; then
        audit_result="** PASS **"
        echo -e "\n- Audit Result:\n$audit_result\n - sudo-ldap is installed."
    fi
fi

# Final output if neither package is found
if [[ $audit_result == "** FAIL **" ]]; then
    echo -e "\n- Audit Result:\n$audit_result\n - Neither sudo nor sudo-ldap is installed."
fi
