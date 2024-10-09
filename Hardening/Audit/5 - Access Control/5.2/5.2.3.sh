#!/usr/bin/env bash

# Function to check for the custom logfile configuration in sudoers
check_sudo_logfile_config() {
    local result
    # Check for the custom logfile setting in the sudoers files
    result=$(grep -rPsi '^\h*Defaults\h+([^#]+,\h*)?logfile\h*=\h*(\"|\')?\H+(\"|\')?(,\h*\H+\h*)*\h*(#.*)?$' /etc/sudoers* 2>/dev/null)
    echo "$result"
}

# Main script execution
echo "Starting audit for sudo logfile configuration..."

# Initialize variables
expected_output='Defaults logfile="/var/log/sudo.log"'
logfile_check=$(check_sudo_logfile_config)

# Check if the logfile is set correctly
if [[ "$logfile_check" == *"$expected_output"* ]]; then
    # If logfile matches the expected output
    audit_result="** PASS **"
    echo -e "\n- Audit Result:\n$audit_result\n - $logfile_check"
else
    # If logfile is not set or configured incorrectly
    audit_result="** FAIL **"
    echo -e "\n- Audit Result:\n$audit_result\n - The expected logfile setting is not found."
    echo -e " - Found:\n$logfile_check"
fi

# Final result
echo -e "\nFinal Audit Result: $audit_result"
