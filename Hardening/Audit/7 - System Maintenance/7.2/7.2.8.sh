#!/usr/bin/env bash

{
    # Initialize output variables
    l_fail_output=""

    # Check for duplicate groups in /etc/group
    while read -r l_count l_group; do
        if [ "$l_count" -gt 1 ]; then
            # Collect duplicate group information
            l_fail_output+="Duplicate Group: \"$l_group\" Groups: \"$(awk -F: '($1 == n) { print $1 }' n=$l_group /etc/group | xargs)\"\n"
        fi
    done < <(cut -f1 -d":" /etc/group | sort -n | uniq -c)

    # Check if there were any duplicate groups found
    if [ -z "$l_fail_output" ]; then
        echo -e "\n- Audit Result:\n ** PASS **\n - * No duplicate groups found in /etc/group. *\n"
    else
        echo -e "\n- Audit Result:\n ** FAIL **\n - * Duplicate groups found: *\n$l_fail_output"
    fi
}
