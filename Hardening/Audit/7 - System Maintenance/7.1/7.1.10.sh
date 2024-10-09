#!/bin/bash

# Define the files to check
files_to_check=("/etc/security/opasswd" "/etc/security/opasswd.old")

# Initialize a variable to track overall pass status
overall_pass=true

# Loop through each file to check
for file in "${files_to_check[@]}"; do
    if [ -e "$file" ]; then
        # Get file information
        file_info=$(stat -c '%n Access: (%#a/%A) Uid: ( %u/ %U) Gid: ( %g/ %G)' "$file")

        # Extract mode, UID, and GID from the stat output
        mode=$(echo "$file_info" | awk '{print $5}' | cut -d'/' -f1)
        uid=$(echo "$file_info" | awk '{print $8}' | cut -d'/' -f1)
        gid=$(echo "$file_info" | awk '{print $11}' | cut -d'/' -f1)

        # Check mode, UID, and GID
        if [[ "$mode" -le 600 && "$uid" -eq 0 && "$gid" -eq 0 ]]; then
            echo "PASS: $file_info"
        else
            echo "FAIL: $file_info"
            overall_pass=false
        fi
    else
        echo "INFO: $file does not exist."
    fi
done

# Final result
echo "-----------------------------------"
if $overall_pass; then
    echo "All tests PASSED."
else
    echo "Some tests FAILED."
fi
