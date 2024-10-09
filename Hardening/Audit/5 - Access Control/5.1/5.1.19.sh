#!/usr/bin/env bash

# Function to check PermitEmptyPasswords
check_permit_empty_passwords() {
    local output

    # Retrieve PermitEmptyPasswords setting from the sshd configuration
    output=$(sshd -T | grep -i permitemptypasswords)

    # Check if output is not empty
    if [[ -n "$output" ]]; then
        # Check if PermitEmptyPasswords is set to 'no'
        if [[ "$output" == *"permitemptypasswords no"* ]]; then
            echo -e "\n- Audit Result:\n ** PASS **\n - PermitEmptyPasswords is set to no."
        else
            echo -e "\n- Audit Result:\n ** FAIL **\n - PermitEmptyPasswords is not set to no. Current setting: $output"
        fi
    else
        echo -e "\n- Audit Result:\n ** FAIL **\n - PermitEmptyPasswords is not set."
    fi
}

# Check for Match directives for a specific user if necessary
check_permit_empty_passwords_for_user() {
    local user="$1"
    local output

    # Retrieve PermitEmptyPasswords setting for the specified user
    output=$(sshd -T -C user="$user" | grep -i permitemptypasswords)

    # Check if output is not empty
    if [[ -n "$output" ]]; then
        # Check if PermitEmptyPasswords is set to 'no'
        if [[ "$output" == *"permitemptypasswords no"* ]]; then
            echo -e "\n- Audit Result for user $user:\n ** PASS **\n - PermitEmptyPasswords is set to no."
        else
            echo -e "\n- Audit Result for user $user:\n ** FAIL **\n - PermitEmptyPasswords is not set to no. Current setting: $output"
        fi
    else
        echo -e "\n- Audit Result for user $user:\n ** FAIL **\n - PermitEmptyPasswords is not set."
    fi
}

# Main script execution
check_permit_empty_passwords  # Check PermitEmptyPasswords

# Optionally, check for a specific user
# Replace 'sshuser' with the actual username you want to check.
# Uncomment the line below if you want to check for a specific user.
# check_permit_empty_passwords_for_user "sshuser"
