#!/usr/bin/env bash

# Initialize output variables
output=""
extended_test_output=""
match_users=()  # Array to hold match user input for extended tests

# Function to check the sshd configuration for the banner setting
check_sshd_banner() {
    # Run the sshd command and filter for the banner setting
    output=$(sshd -T | grep -Pi -- '^banner\h+\/\H+')

    # Verify if output contains expected banner line
    if [[ -n "$output" ]]; then
        echo -e "\n- Audit Result:\n ** PASS **\n - Found banner configuration:\n$output"
    else
        echo -e "\n- Audit Result:\n ** FAIL **\n - No banner configuration found."
    fi
}

# Function to check match block settings for specific users
check_match_block() {
    for user in "${match_users[@]}"; do
        extended_test_output=$(sshd -T -C user="$user" | grep -Pi -- '^banner\h+\/\H+')

        if [[ -n "$extended_test_output" ]]; then
            echo -e "\n- Match Block Result for user \"$user\":\n ** PASS **\n - Found banner configuration:\n$extended_test_output"
        else
            echo -e "\n- Match Block Result for user \"$user\":\n ** FAIL **\n - No banner configuration found in match block."
        fi
    done
}

# Main script execution
check_sshd_banner  # Check general sshd config for banner setting

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
