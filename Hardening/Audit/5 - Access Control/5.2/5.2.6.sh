#!/usr/bin/env bash

# Function to check the timestamp_timeout value in sudoers files
check_timestamp_timeout() {
    # Check for timestamp_timeout in sudoers files
    timeout_value=$(grep -roP "timestamp_timeout=\K[0-9]*" /etc/sudoers* 2>/dev/null)
    echo "$timeout_value"
}

# Function to check the default timeout using sudo -V
check_default_timeout() {
    default_timeout=$(sudo -V | grep "Authentication timestamp timeout:" | awk '{print $NF}')
    echo "$default_timeout"
}

# Main script execution
echo "Starting audit for sudo caching timeout..."

# Check for configured timeout
configured_timeout=$(check_timestamp_timeout)

if [[ -n "$configured_timeout" ]]; then
    # If timestamp_timeout is configured
    if (( configured_timeout > 15 )); then
        audit_result="** FAIL **"
        echo -e "\n- Audit Result:\n$audit_result"
        echo -e " - timestamp_timeout is set to $configured_timeout minutes, which exceeds the maximum allowed of 15 minutes."
    else
        audit_result="** PASS **"
        echo -e "\n- Audit Result:\n$audit_result"
        echo -e " - timestamp_timeout is set to $configured_timeout minutes, which is within the acceptable range."
    fi
else
    # If no timeout is configured, check the default
    default_timeout=$(check_default_timeout)
    if [[ "$default_timeout" == "-1" ]]; then
        audit_result="** FAIL **"
        echo -e "\n- Audit Result:\n$audit_result"
        echo -e " - The caching timeout is disabled (-1). This could lead to security issues."
    else
        audit_result="** PASS **"
        echo -e "\n- Audit Result:\n$audit_result"
        echo -e " - No timestamp_timeout configured; default is $default_timeout minutes, which is within the acceptable range."
    fi
fi

# Final result
echo -e "\nFinal Audit Result: $audit_result"
