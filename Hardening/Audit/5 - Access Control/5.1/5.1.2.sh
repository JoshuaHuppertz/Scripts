#!/usr/bin/env bash

# Initialize output variables
l_output=""
l_output2=""
l_ssh_group_name="$(awk -F: '($1 ~ /^(ssh_keys|_?ssh)$/) {print $1}' /etc/group)"  # Identify SSH group names

# Function to check file permissions, ownership, and group ownership
FILE_CHK() {
    while IFS=: read -r l_file_mode l_file_owner l_file_group; do
        l_out2=""
        
        # Set permission mask based on group ownership
        if [ "$l_file_group" = "$l_ssh_group_name" ]; then
            l_pmask="0137"
        else
            l_pmask="0177"
        fi
        
        l_maxperm="$( printf '%o' $(( 0777 & ~$l_pmask )) )"  # Calculate max allowed permissions
        
        # Check permissions
        if [ $(( l_file_mode & l_pmask )) -gt 0 ]; then
            l_out2="$l_out2\n - Mode: \"$l_file_mode\" should be mode: \"$l_maxperm\" or more restrictive"
        fi
        
        # Check ownership
        if [ "$l_file_owner" != "root" ]; then
            l_out2="$l_out2\n - Owned by: \"$l_file_owner\" should be owned by \"root\""
        fi
        
        # Check group ownership
        if [[ ! "$l_file_group" =~ ($l_ssh_group_name|root) ]]; then
            l_out2="$l_out2\n - Owned by group \"$l_file_group\" should be group owned by: \"$l_ssh_group_name\" or \"root\""
        fi
        
        # Append results based on findings
        if [ -n "$l_out2" ]; then
            l_output2="$l_output2\n - File: \"$l_file\"$l_out2"
        else
            l_output="$l_output\n - File: \"$l_file\"\n - Correct: mode: \"$l_file_mode\", owner: \"$l_file_owner\", and group owner: \"$l_file_group\" configured"
        fi
    done < <(stat -Lc '%#a:%U:%G' "$l_file")  # Retrieve file status
}

# Main script logic to find and check SSH private key files
while IFS= read -r -d $'\0' l_file; do
    if ssh-keygen -lf &>/dev/null "$l_file"; then  # Check if the file is an SSH key
        # Check if the file is an OpenSSH private key
        if file "$l_file" | grep -Piq '\bopenssh\h+([^#\n\r]+\h+)?private\h+key\b'; then
            FILE_CHK  # Call the file checking function
        fi
    fi
done < <(find -L /etc/ssh -xdev -type f -print0 2>/dev/null)  # Find all files in /etc/ssh

# Output the results of the audit
if [ -z "$l_output2" ]; then
    # If no issues found, indicate all files are correctly configured
    [ -z "$l_output" ] && l_output="\n - No openSSH private keys found"
    echo -e "\n- Audit Result:\n ** PASS **\n - * Correctly configured *:$l_output"
else
    # If issues found, indicate failure and list issues
    echo -e "\n- Audit Result:\n ** FAIL **\n - * Reasons for audit failure * :$l_output2\n"
    [ -n "$l_output" ] && echo -e "\n - * Correctly configured *:\n$l_output\n"
fi
