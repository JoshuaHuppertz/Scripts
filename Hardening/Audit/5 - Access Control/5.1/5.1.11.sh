#!/usr/bin/env bash

# Function to check if IgnoreRhosts is set to yes
check_ignorerhosts() {
    local output
    output=$(sshd -T | grep ignorerhosts)

    # Initialize the pass/fail flag
    local ignorerhosts_value=""

    # Check if the output contains the IgnoreRhosts setting
    if [[ $output =~ ^ignorerhosts\ (yes|no) ]]; then
        ignorerhosts_value="${BASH_REMATCH[1]}"
        
        # Check if the value is 'yes'
        if [[ "$ignorerhosts_value" == "yes" ]]; then
            echo -e "\n- Audit Result:\n ** PASS **\n - IgnoreRhosts is set to: $ignorerhosts_value"
        else
            echo -e "\n- Audit Result:\n ** FAIL **\n - IgnoreRhosts must be set to 'yes': current value is $ignorerhosts_value"
        fi
    else
        echo -e "\n- Audit Result:\n ** FAIL **\n - IgnoreRhosts setting is not found in the configuration."
    fi
}

# Main script execution
check_ignorerhosts  # Check the IgnoreRhosts setting
