#!/usr/bin/env bash

# Function to check if HostbasedAuthentication is set to no
check_hostbased_authentication() {
    local output
    output=$(sshd -T | grep hostbasedauthentication)

    # Initialize the pass/fail flag
    local hostbased_auth_value=""

    # Check if the output contains the HostbasedAuthentication setting
    if [[ $output =~ ^hostbasedauthentication\ (yes|no) ]]; then
        hostbased_auth_value="${BASH_REMATCH[1]}"
        
        # Check if the value is 'no'
        if [[ "$hostbased_auth_value" == "no" ]]; then
            echo -e "\n- Audit Result:\n ** PASS **\n - HostbasedAuthentication is set to: $hostbased_auth_value"
        else
            echo -e "\n- Audit Result:\n ** FAIL **\n - HostbasedAuthentication must be set to 'no': current value is $hostbased_auth_value"
        fi
    else
        echo -e "\n- Audit Result:\n ** FAIL **\n - HostbasedAuthentication setting is not found in the configuration."
    fi
}

# Main script execution
check_hostbased_authentication  # Check the HostbasedAuthentication setting
