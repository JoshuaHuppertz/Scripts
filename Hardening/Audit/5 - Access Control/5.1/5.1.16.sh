#!/usr/bin/env bash

# Function to check MaxAuthTries
check_max_auth_tries() {
    local output
    local max_auth_tries

    # Retrieve MaxAuthTries setting from the sshd configuration
    output=$(sshd -T | grep maxauthtries)

    # Check if output is not empty
    if [[ -n "$output" ]]; then
        # Extract the value of MaxAuthTries
        max_auth_tries=$(echo "$output" | awk '{print $2}')

        # Check if MaxAuthTries is 4 or less
        if (( max_auth_tries <= 4 )); then
            echo -e "\n- Audit Result:\n ** PASS **\n - MaxAuthTries is set to $max_auth_tries (4 or less)."
        else
            echo -e "\n- Audit Result:\n ** FAIL **\n - MaxAuthTries is set to $max_auth_tries (greater than 4)."
        fi
    else
        echo -e "\n- Audit Result:\n ** FAIL **\n - MaxAuthTries is not set."
    fi
}

# Main script execution
check_max_auth_tries  # Check MaxAuthTries
