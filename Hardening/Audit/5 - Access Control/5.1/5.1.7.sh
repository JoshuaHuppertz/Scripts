#!/usr/bin/env bash

# Function to check ClientAliveInterval and ClientAliveCountMax
check_client_alive_settings() {
    local output
    output=$(sshd -T | grep -Pi -- '(clientaliveinterval|clientalivecountmax)')
    
    # Initialize flags for pass/fail
    local client_alive_interval=0
    local client_alive_count_max=0

    # Process the output
    while IFS= read -r line; do
        if [[ $line =~ ^clientaliveinterval\ ([0-9]+) ]]; then
            client_alive_interval="${BASH_REMATCH[1]}"
        elif [[ $line =~ ^clientalivecountmax\ ([0-9]+) ]]; then
            client_alive_count_max="${BASH_REMATCH[1]}"
        fi
    done <<< "$output"

    # Check if both settings are greater than zero
    if (( client_alive_interval > 0 && client_alive_count_max > 0 )); then
        echo -e "\n- Audit Result:\n ** PASS **\n - ClientAliveInterval: $client_alive_interval\n - ClientAliveCountMax: $client_alive_count_max"
    else
        echo -e "\n- Audit Result:\n ** FAIL **\n - ClientAliveInterval must be greater than zero: $client_alive_interval\n - ClientAliveCountMax must be greater than zero: $client_alive_count_max"
    fi
}

# Function to check ClientAlive settings for a specific user with match blocks
check_client_alive_with_match() {
    local user="$1"
    local output
    output=$(sshd -T -C user="$user" | grep -Pi -- '(clientaliveinterval|clientalivecountmax)')

    # Initialize flags for pass/fail
    local client_alive_interval=0
    local client_alive_count_max=0

    # Process the output
    while IFS= read -r line; do
        if [[ $line =~ ^clientaliveinterval\ ([0-9]+) ]]; then
            client_alive_interval="${BASH_REMATCH[1]}"
        elif [[ $line =~ ^clientalivecountmax\ ([0-9]+) ]]; then
            client_alive_count_max="${BASH_REMATCH[1]}"
        fi
    done <<< "$output"

    # Check if both settings are greater than zero
    if (( client_alive_interval > 0 && client_alive_count_max > 0 )); then
        echo -e "\n- Audit Result for user '$user':\n ** PASS **\n - ClientAliveInterval: $client_alive_interval\n - ClientAliveCountMax: $client_alive_count_max"
    else
        echo -e "\n- Audit Result for user '$user':\n ** FAIL **\n - ClientAliveInterval must be greater than zero: $client_alive_interval\n - ClientAliveCountMax must be greater than zero: $client_alive_count_max"
    fi
}

# Main script execution
check_client_alive_settings  # Check global settings

# Uncomment the line below to check specific user settings with Match blocks
# check_client_alive_with_match "sshuser"  # Replace "sshuser" with the actual username if needed
