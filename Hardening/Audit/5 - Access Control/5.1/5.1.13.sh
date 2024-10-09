#!/usr/bin/env bash

# Function to check LoginGraceTime
check_login_grace_time() {
    local output
    local grace_time

    # Retrieve the LoginGraceTime setting from the sshd configuration
    output=$(sshd -T | grep logingracetime)

    # Check if the output is empty
    if [[ -z "$output" ]]; then
        echo -e "\n- Audit Result:\n ** FAIL **\n - LoginGraceTime is not set."
        return
    fi

    # Extract the grace time value
    grace_time=$(echo "$output" | awk '{print $2}')

    # Check if the grace time is between 1 and 60 seconds
    if [[ "$grace_time" -ge 1 && "$grace_time" -le 60 ]]; then
        echo -e "\n- Audit Result:\n ** PASS **\n - LoginGraceTime is set to $grace_time seconds."
    else
        echo -e "\n- Audit Result:\n ** FAIL **\n - LoginGraceTime is set to $grace_time seconds, which is outside the acceptable range (1-60 seconds)."
    fi
}

# Main script execution
check_login_grace_time  # Check LoginGraceTime setting
