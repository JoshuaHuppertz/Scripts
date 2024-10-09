#!/usr/bin/env bash

# Function to check if GSSAPIAuthentication is set to no
check_gssapi_authentication() {
    local output
    output=$(sshd -T | grep gssapiauthentication)

    # Initialize the pass/fail flag
    local gssapi_auth_value=""

    # Check if the output contains the GSSAPIAuthentication setting
    if [[ $output =~ ^gssapiauthentication\ (yes|no) ]]; then
        gssapi_auth_value="${BASH_REMATCH[1]}"
        
        # Check if the value is 'no'
        if [[ "$gssapi_auth_value" == "no" ]]; then
            echo -e "\n- Audit Result:\n ** PASS **\n - GSSAPIAuthentication is set to: $gssapi_auth_value"
        else
            echo -e "\n- Audit Result:\n ** FAIL **\n - GSSAPIAuthentication must be set to 'no': current value is $gssapi_auth_value"
        fi
    else
        echo -e "\n- Audit Result:\n ** FAIL **\n - GSSAPIAuthentication setting is not found in the configuration."
    fi
}

# Main script execution
check_gssapi_authentication  # Check the GSSAPIAuthentication setting
