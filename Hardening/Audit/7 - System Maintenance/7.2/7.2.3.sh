#!/usr/bin/env bash

{
    # Initialize arrays to hold GIDs from passwd and group
    a_passwd_group_gid=($(awk -F: '{print $4}' /etc/passwd | sort -u))
    a_group_gid=($(awk -F: '{print $3}' /etc/group | sort -u))
    
    # Find the GIDs that are in passwd but not in group
    a_passwd_group_diff=($(printf '%s\n' "${a_group_gid[@]}" "${a_passwd_group_gid[@]}" | sort | uniq -u))
    
    # Initialize output messages
    l_output=""
    l_fail_output=""
    
    # Check for users with GIDs that do not exist in /etc/group
    for l_gid in "${a_passwd_group_diff[@]}"; do
        while IFS= read -r l_user; do
            l_fail_output+=" - User: \"$l_user\" has GID: \"$l_gid\" which does not exist in /etc/group\n"
        done < <(awk -F: '($4 == "'"$l_gid"'") {print $1}' /etc/passwd)
    done
    
    # Check if there are any users with invalid GIDs
    if [ -z "$l_fail_output" ]; then
        echo -e "\n- Audit Result:\n ** PASS **\n - * All user GIDs are valid and exist in /etc/group. *\n"
    else
        echo -e "\n- Audit Result:\n ** FAIL **\n - * Users with invalid GIDs detected: *\n$l_fail_output"
    fi
    
    # Clean up arrays
    unset a_passwd_group_gid a_group_gid a_passwd_group_diff
}
