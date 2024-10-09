#!/usr/bin/env bash

# Function to check for Defaults use_pty in sudoers
check_use_pty_set() {
    local result
    result=$(grep -rPi -- '^\h*Defaults\h+([^#\n\r]+,)?use_pty(,\h*\h+\h*)*\h*(#.*)?$' /etc/sudoers* 2>/dev/null)
    echo "$result"
}

# Function to check for Defaults !use_pty in sudoers
check_use_pty_not_set() {
    local result
    result=$(grep -rPi -- '^\h*Defaults\h+([^#\n\r]+,)?!use_pty(,\h*\h+\h*)*\h*(#.*)?$' /etc/sudoers* 2>/dev/null)
    echo "$result"
}

# Main script execution
echo "Starting audit for sudo use_pty configuration..."

# Initialize audit result
audit_result="** FAIL **"
use_pty_check=$(check_use_pty_set)
use_pty_not_check=$(check_use_pty_not_set)

# Check if Defaults use_pty is set correctly
if [[ -n "$use_pty_check" ]]; then
    # If use_pty is found, we have a positive check
    audit_result="** PASS **"
    echo -e "\n- Audit Result:\n$audit_result\n - $use_pty_check"
else
    echo -e "\n- Audit Result:\n** FAIL **\n - Defaults use_pty is not set."
fi

# Check if Defaults !use_pty is not set
if [[ -z "$use_pty_not_check" ]]; then
    echo -e "\n- Audit Check: Defaults !use_pty is NOT set."
else
    echo -e "\n- Audit Check: Defaults !use_pty is set, which is a configuration error."
    audit_result="** FAIL **"
fi

# Final result
echo -e "\nFinal Audit Result: $audit_result"
