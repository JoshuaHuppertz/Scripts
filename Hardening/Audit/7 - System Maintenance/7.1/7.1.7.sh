#!/bin/bash

# Define the file to check
file_to_check="/etc/gshadow"

# Get the file information
file_info=$(stat -c 'Access: (%#a/%A) Uid: ( %u/ %U) Gid: ( %g/ %G)' "$file_to_check")

# Initialize pass variable
pass=true

# Extract mode, UID, and GID from the stat output
mode=$(echo "$file_info" | awk '{print $2}' | cut -d'/' -f1)
uid=$(echo "$file_info" | awk '{print $5}' | cut -d'/' -f1)
gid=$(echo "$file_info" | awk '{print $8}' | cut -d'/' -f1)

# Check mode, UID, and GID
if [[ "$mode" -le 640 && "$uid" -eq 0 && ( "$gid" -eq 0 || "$gid" -eq 42 ) ]]; then
    echo "PASS: $file_info"
else
    echo "FAIL: $file_info"
    pass=false
fi

# Final result
echo "-----------------------------------"
if [[ "$pass" == true ]]; then
    echo "Test for $file_to_check PASSED."
else
    echo "Test for $file_to_check FAILED."
fi
