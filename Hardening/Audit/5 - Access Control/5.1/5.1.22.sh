#!/usr/bin/env bash

# Function to check UsePAM
check_use_pam() {
    local output

    # Retrieve UsePAM setting from the sshd configuration
    output=$(sshd -T | grep -i usepam)

    # Check if output is not empty
    if [[ -n "$output" ]]; then
        # Check if UsePAM is set to 'yes'
        if [[ "$output" == *"usepam yes"* ]]; then
            echo -e "\n- Audit Result:\n ** PASS **\n - UsePAM is set to yes."
        else
            echo -e "\n- Audit Result:\n ** FAIL **\n - UsePAM is not set to yes. Current setting: $output"
        fi
    else
        echo -e "\n- Audit Result:\n ** FAIL **\n - UsePAM is not set."
    fi
}

# Check for Match directives for a specific user if necessary
check_use_pam_for_user() {
    local user="$1"
    local output

    # Retrieve UsePAM setting for the specified user
    output=$(sshd -T -C user="$user" | grep -i usepam)

    # Check if output is not empty
    if [[ -n "$output" ]]; then
        # Check if UsePAM is set to 'yes'
        if [[ "$output" == *"usepam yes"* ]]; then
            echo -e "\n- Audit Result for user $user:\n ** PASS **\n - UsePAM is set to yes."
        else
            echo -e "\n- Audit Result for user $user:\n ** FAIL **\n - UsePAM is not set to yes. Current setting: $output"
        fi
    else
        echo -e "\n- Audit Result for user $user:\n ** FAIL **\n - UsePAM is not set."
    fi
}

# Main script execution
check_use_pam  # Check global UsePAM setting

# Optionally, check for a specific user
# Replace 'sshuser' with the actual username you want to check.
# Uncomment the line below if you want to check for a specific user.
# check_use_pam_for_user "sshuser"
