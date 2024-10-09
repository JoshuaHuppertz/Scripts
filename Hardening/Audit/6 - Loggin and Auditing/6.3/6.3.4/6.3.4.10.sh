#!/bin/bash

# Define the audit tools to check
audit_tools=(
    "/sbin/auditctl"
    "/sbin/aureport"
    "/sbin/ausearch"
    "/sbin/autrace"
    "/sbin/auditd"
    "/sbin/augenrules"
)

# Initialize a variable to track the result
pass=true

# Header for output
echo "Checking ownership of audit tools..."
echo "-----------------------------------"

# Loop through each audit tool and check its group ownership
for tool in "${audit_tools[@]}"; do
    group=$(stat -c "%G" "$tool")
    
    # Check if the group is 'root'
    if [[ "$group" != "root" ]]; then
        echo "FAIL: $tool is owned by group '$group'"
        pass=false
    else
        echo "PASS: $tool is owned by group 'root'"
    fi
done

# Final result
echo "-----------------------------------"
if [[ "$pass" == true ]]; then
    echo "All audit tools are owned by group 'root'. PASSED."
else
    echo "Some audit tools are NOT owned by group 'root'. FAILED."
fi
