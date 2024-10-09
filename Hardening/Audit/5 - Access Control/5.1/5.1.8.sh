#!/usr/bin/env bash

# Function to check if DisableForwarding is set to yes
check_disable_forwarding() {
    local output
    output=$(sshd -T | grep -i disableforwarding)

    # Initialize the pass/fail flag
    local disable_forwarding_value=""

    # Check if the output contains the DisableForwarding setting
    if [[ $output =~ ^disableforwarding\ (yes|no) ]]; then
        disable_forwarding_value="${BASH_REMATCH[1]}"
        
        # Check if the value is 'yes'
        if [[ "$disable_forwarding_value" == "yes" ]]; then
            echo -e "\n- Audit Result:\n ** PASS **\n - DisableForwarding is set to: $disable_forwarding_value"
        else
            echo -e "\n- Audit Result:\n ** FAIL **\n - DisableForwarding must be set to 'yes': current value is $disable_forwarding_value"
        fi
    else
        echo -e "\n- Audit Result:\n ** FAIL **\n - DisableForwarding setting is not found in the configuration."
    fi
}

# Main script execution
check_disable_forwarding  # Check the DisableForwarding setting
