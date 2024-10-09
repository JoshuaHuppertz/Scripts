#!/usr/bin/env bash

{
    # Check if the "shadow" group exists and get its GID
    shadow_gid=$(getent group shadow | awk -F: '{print $3}')
    
    # Initialize output messages
    l_fail_output=""
    
    # Check if the shadow group exists
    if [ -z "$shadow_gid" ]; then
        echo -e "\n- Audit Result:\n ** FAIL **\n - * The 'shadow' group does not exist on the system. *\n"
        exit 1
    fi

    # Check if any users have the shadow group as their primary group
    while IFS= read -r user; do
        l_fail_output+=" - User: \"$user\" has the 'shadow' group as their primary group\n"
    done < <(awk -F: -v gid="$shadow_gid" '($4 == gid) {print $1}' /etc/passwd)
    
    # Check if any users were found
    if [ -z "$l_fail_output" ]; then
        echo -e "\n- Audit Result:\n ** PASS **\n - * No users have the 'shadow' group as their primary group. *\n"
    else
        echo -e "\n- Audit Result:\n ** FAIL **\n - * The following users have the 'shadow' group as their primary group: *\n$l_fail_output"
    fi
}
