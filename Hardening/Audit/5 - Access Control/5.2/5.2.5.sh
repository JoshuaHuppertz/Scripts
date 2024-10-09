#!/usr/bin/env bash

# Function to check for !authenticate entries in sudoers files
check_authenticate_entries() {
    # Check for any !authenticate entries in the sudoers files
    grep -r "^[^#].*\!authenticate" /etc/sudoers* 2>/dev/null
}

# Main script execution
echo "Starting audit for re-authentication requirement on privilege escalation..."

# Run the check
auth_check=$(check_authenticate_entries)

# Check if any !authenticate entries are found
if [[ -n "$auth_check" ]]; then
    # If any !authenticate entries are found
    audit_result="** FAIL **"
    echo -e "\n- Audit Result:\n$audit_result"
    echo -e " - !authenticate entries found:\n$auth_check"
    echo -e "\n** Remediation Required: Please review the entries in the sudoers configuration and remove any !authenticate tags to ensure users are required to re-authenticate for privilege escalation. **"
else
    # If no !authenticate entries are found
    audit_result="** PASS **"
    echo -e "\n- Audit Result:\n$audit_result"
    echo -e " - No !authenticate entries found. Users must re-authenticate for privilege escalation."
fi

# Final result
echo -e "\nFinal Audit Result: $audit_result"
