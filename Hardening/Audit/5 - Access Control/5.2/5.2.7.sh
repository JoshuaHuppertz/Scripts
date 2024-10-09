#!/usr/bin/env bash

# Set the expected group name (replace <group_name> with the actual group name)
GROUP_NAME="<group_name>"  # Replace this with the actual group name

# Function to check PAM configuration
check_pam_wheel() {
    # Check the PAM configuration for pam_wheel.so
    output=$(grep -Pi '^\h*auth\h+(?:required|requisite)\h+pam_wheel\.so\h+(?:[^#\n\r]+\h+)?((?!\2)(use_uid\b|group=\H+\b))\h+(?:[^#\n\r]+\h+)?((?!\1)(use_uid\b|group=\H+\b))(h+.*)?$' /etc/pam.d/su)
    echo "$output"
}

# Function to check group membership
check_group_membership() {
    group_output=$(grep "$GROUP_NAME" /etc/group)
    echo "$group_output"
}

# Main script execution
echo "Starting audit for PAM wheel configuration..."

# Check PAM configuration for pam_wheel
pam_output=$(check_pam_wheel)

if [[ -n "$pam_output" ]]; then
    # Check if the output matches the expected format
    if [[ "$pam_output" == *"auth required pam_wheel.so use_uid group=$GROUP_NAME"* ]]; then
        echo -e "\n- PAM Configuration:\n** PASS **"
        echo " - PAM is correctly configured for pam_wheel.so with group: $GROUP_NAME."
        
        # Check the specified group for users
        group_output=$(check_group_membership)
        
        if [[ -z "$group_output" ]]; then
            echo -e "\n- Group Membership Check:\n** PASS **"
            echo " - The group '$GROUP_NAME' contains no users."
        else
            echo -e "\n- Group Membership Check:\n** FAIL **"
            echo " - The group '$GROUP_NAME' contains the following users:"
            echo "$group_output"
        fi
    else
        echo -e "\n- PAM Configuration:\n** FAIL **"
        echo " - PAM is not configured correctly for pam_wheel.so. Output:"
        echo "$pam_output"
    fi
else
    echo -e "\n- PAM Configuration:\n** FAIL **"
    echo " - No configuration for pam_wheel.so found in /etc/pam.d/su."
fi

# Final result
echo -e "\nAudit completed."
