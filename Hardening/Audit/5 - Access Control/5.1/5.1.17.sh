#!/usr/bin/env bash

# Function to check MaxSessions
check_max_sessions() {
    local output
    local max_sessions

    # Retrieve MaxSessions setting from the sshd configuration
    output=$(sshd -T | grep -i maxsessions)

    # Check if output is not empty
    if [[ -n "$output" ]]; then
        # Extract the value of MaxSessions
        max_sessions=$(echo "$output" | awk '{print $2}')

        # Check if MaxSessions is 10 or less
        if (( max_sessions <= 10 )); then
            echo -e "\n- Audit Result:\n ** PASS **\n - MaxSessions is set to $max_sessions (10 or less)."
        else
            echo -e "\n- Audit Result:\n ** FAIL **\n - MaxSessions is set to $max_sessions (greater than 10)."
        fi
    else
        echo -e "\n- Audit Result:\n ** FAIL **\n - MaxSessions is not set."
    fi

    # Check for any occurrences of MaxSessions greater than 10 in config files
    echo -e "\n- Checking SSH configuration files for MaxSessions greater than 10..."
    if grep -Psi -- '^\h*MaxSessions\h+\"?(1[1-9]|[2-9][0-9]|[1-9][0-9][0-9]+)\b' /etc/ssh/sshd_config /etc/ssh/sshd_config.d/*.conf; then
        echo -e " - Audit Result:\n ** FAIL **\n - Found configurations with MaxSessions set greater than 10."
    else
        echo -e " - Audit Result:\n ** PASS **\n - No configurations with MaxSessions set greater than 10 found."
    fi
}

# Main script execution
check_max_sessions  # Check MaxSessions
