#!/usr/bin/env bash

{
    # Initialize output variables
    l_fail_output=""
    
    # Check for duplicate GIDs
    while read -r l_count l_gid; do
        if [ "$l_count" -gt 1 ]; then
            # Collect duplicate GID information
            l_fail_output+="Duplicate GID: \"$l_gid\" Groups: \"$(awk -F: '($3 == n) {print $1 }' n=$l_gid /etc/group | xargs)\"\n"
        fi
    done < <(cut -f3 -d":" /etc/group | sort -n | uniq -c)

    # Check if there were any duplicate GIDs found
    if [ -z "$l_fail_output" ]; then
        echo -e "\n- Audit Result:\n ** PASS **\n - * No duplicate GIDs found in /etc/group. *\n"
    else
        echo -e "\n- Audit Result:\n ** FAIL **\n - * Duplicate GIDs found: *\n$l_fail_output"
    fi
}
