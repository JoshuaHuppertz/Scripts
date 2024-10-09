#!/usr/bin/env bash

# Function to check PermitRootLogin
check_permit_root_login() {
    local output

    # Retrieve PermitRootLogin setting from the sshd configuration
    output=$(sshd -T | grep -i permitrootlogin)

    # Check if output is not empty
    if [[ -n "$output" ]]; then
        # Check if PermitRootLogin is set to 'no'
        if [[ "$output" == *"permitrootlogin no"* ]]; then
            echo -e "\n- Audit Result:\n ** PASS **\n - PermitRootLogin is set to no."
        else
            echo -e "\n- Audit Result:\n ** FAIL **\n - PermitRootLogin is not set to no. Current setting: $output"
        fi
    else
        echo -e "\n- Audit Result:\n ** FAIL **\n - PermitRootLogin is not set."
    fi
}

# Check for Match directives for a specific user if necessary
check_permit_root_login_for_user() {
    local user="$1"
    local output

    # Retrieve PermitRootLogin setting for the specified user
    output=$(sshd -T -C user="$user" | grep -i permitrootlogin)

    # Check if output is not empty
    if [[ -n "$output" ]]; then
        # Check if PermitRootLogin is set to 'no'
        if [[ "$output" == *"permitrootlogin no"* ]]; then
            echo -e "\n- Audit Result for user $user:\n ** PASS **\n - PermitRootLogin is set to no."
        else
            echo -e "\n- Audit Result for user $user:\n ** FAIL **\n - PermitRootLogin is not set to no. Current setting: $output"
        fi
    else
        echo -e "\n- Audit Result for user $user:\n ** FAIL **\n - PermitRootLogin is not set."
    fi
}

# Main script execution
check_permit_root_login  # Check PermitRootLogin

# Optionally, check for a specific user
# Replace 'sshuser' with the actual username you want to check.
# Uncomment the line below if you want to check for a specific user.
# check_permit_root_login_for_user "sshuser"
