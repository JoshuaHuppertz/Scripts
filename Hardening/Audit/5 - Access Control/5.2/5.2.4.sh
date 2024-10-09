#!/usr/bin/env bash

# Function to check for NOPASSWD entries in sudoers files
check_nopasswd_entries() {
    local result
    # Check for any NOPASSWD entries in the sudoers files
    result=$(grep -r "^[^#].*NOPASSWD" /etc/sudoers* 2>/dev/null)
    echo "$result"
}

# Main script execution
echo "Starting audit for password requirement on privilege escalation..."

# Run the check
nopasswd_check=$(check_nopasswd_entries)

# Check if any NOPASSWD entries are found
if [[ -n "$nopasswd_check" ]]; then
    # If any NOPASSWD entries are found
    audit_result="** FAIL **"
    echo -e "\n- Audit Result:\n$audit_result\n - NOPASSWD entries found:\n$nopasswd_check"
else
    # If no NOPASSWD entries are found
    audit_result="** PASS **"
    echo -e "\n- Audit Result:\n$audit_result\n - No NOPASSWD entries found. Users must provide a password for privilege escalation."
fi

# Final result
echo -e "\nFinal Audit Result: $audit_result"
