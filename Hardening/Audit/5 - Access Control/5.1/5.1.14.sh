#!/usr/bin/env bash

# Function to check LogLevel
check_log_level() {
    local output
    local log_level

    # Retrieve the LogLevel setting from the sshd configuration
    output=$(sshd -T | grep loglevel)

    # Check if the output is empty
    if [[ -z "$output" ]]; then
        echo -e "\n- Audit Result:\n ** FAIL **\n - LogLevel is not set."
        return
    fi

    # Extract the log level value
    log_level=$(echo "$output" | awk '{print $2}')

    # Check if the log level is either VERBOSE or INFO
    if [[ "$log_level" == "VERBOSE" || "$log_level" == "INFO" ]]; then
        echo -e "\n- Audit Result:\n ** PASS **\n - LogLevel is set to $log_level."
    else
        echo -e "\n- Audit Result:\n ** FAIL **\n - LogLevel is set to $log_level, which is not allowed. It should be VERBOSE or INFO."
    fi
}

# Main script execution
check_log_level  # Check LogLevel setting
