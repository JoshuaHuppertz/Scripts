#!/usr/bin/env bash

# Initialize output variables
output=""
extended_test_output=""
match_users=()  # Array to hold match user input for extended tests

# Function to check the sshd configuration for user/group allow/deny statements
check_sshd_config() {
    # Run the sshd command and filter for allow/deny statements
    output=$(sshd -T | grep -Pi -- '^\h*(allow|deny)(users|groups)\h+\H+')

    # Verify if output contains expected lines
    if [[ -n "$output" ]]; then
        echo -e "\n- Audit Result:\n ** PASS **\n - Found configuration statements:\n$output"
    else
        echo -e "\n- Audit Result:\n ** FAIL **\n - No valid allow/deny statements found."
    fi
}

# Function to check match block settings for specific users
check_match_block() {
    for user in "${match_users[@]}"; do
        extended_test_output=$(sshd -T -C user="$user" | grep -Pi -- '^\h*(allow|deny)(users|groups)\h+\H+')

        if [[ -n "$extended_test_output" ]]; then
            echo -e "\n- Match Block Result for user \"$user\":\n ** PASS **\n - Found configuration statements:\n$extended_test_output"
        else
            echo -e "\n- Match Block Result for user \"$user\":\n ** FAIL **\n - No valid allow/deny statements found in match block."
        fi
    done
}

# Main script execution
check_sshd_config  # Check general sshd config for allow/deny statements

# Prompt user for match users if needed
read -p "Do you want to check for specific users in match blocks? (yes/no): " user_input
if [[ "$user_input" =~ ^[Yy][Ee][Ss]$ ]]; then
    while true; do
        read -p "Enter a username for the match block (or type 'done' to finish): " user
        if [[ "$user" == "done" ]]; then
            break
        fi
        match_users+=("$user")
    done
    check_match_block  # Check match block settings for specified users
fi
