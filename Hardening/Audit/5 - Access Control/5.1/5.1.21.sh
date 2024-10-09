#!/usr/bin/env bash

# Function to check PermitUserEnvironment
check_permit_user_environment() {
    local output

    # Retrieve PermitUserEnvironment setting from the sshd configuration
    output=$(sshd -T | grep -i permituserenvironment)

    # Check if output is not empty
    if [[ -n "$output" ]]; then
        # Check if PermitUserEnvironment is set to 'no'
        if [[ "$output" == *"permituserenvironment no"* ]]; then
            echo -e "\n- Audit Result:\n ** PASS **\n - PermitUserEnvironment is set to no."
        else
            echo -e "\n- Audit Result:\n ** FAIL **\n - PermitUserEnvironment is not set to no. Current setting: $output"
        fi
    else
        echo -e "\n- Audit Result:\n ** FAIL **\n - PermitUserEnvironment is not set."
    fi
}

# Check for Match directives for a specific user if necessary
check_permit_user_environment_for_user() {
    local user="$1"
    local output

    # Retrieve PermitUserEnvironment setting for the specified user
    output=$(sshd -T -C user="$user" | grep -i permituserenvironment)

    # Check if output is not empty
    if [[ -n "$output" ]]; then
        # Check if PermitUserEnvironment is set to 'no'
        if [[ "$output" == *"permituserenvironment no"* ]]; then
            echo -e "\n- Audit Result for user $user:\n ** PASS **\n - PermitUserEnvironment is set to no."
        else
            echo -e "\n- Audit Result for user $user:\n ** FAIL **\n - PermitUserEnvironment is not set to no. Current setting: $output"
        fi
    else
        echo -e "\n- Audit Result for user $user:\n ** FAIL **\n - PermitUserEnvironment is not set."
    fi
}

# Main script execution
check_permit_user_environment  # Check PermitUserEnvironment

# Optionally, check for a specific user
# Replace 'sshuser' with the actual username you want to check.
# Uncomment the line below if you want to check for a specific user.
# check_permit_user_environment_for_user "sshuser"
