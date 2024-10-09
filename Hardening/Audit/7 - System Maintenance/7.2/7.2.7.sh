#!/usr/bin/env bash

{
    # Initialize output variables
    l_fail_output=""

    # Check for duplicate users in /etc/group
    while read -r l_count l_user; do
        if [ "$l_count" -gt 1 ]; then
            # Collect duplicate user information
            l_fail_output+="Duplicate User: \"$l_user\" Users: \"$(awk -F: '($1 == n) {print $1 }' n=$l_user /etc/passwd | xargs)\"\n"
        fi
    done < <(cut -f1 -d":" /etc/group | sort -n | uniq -c)

    # Check if there were any duplicate users found
    if [ -z "$l_fail_output" ]; then
        echo -e "\n- Audit Result:\n ** PASS **\n - * No duplicate users found in /etc/group. *\n"
    else
        echo -e "\n- Audit Result:\n ** FAIL **\n - * Duplicate users found: *\n$l_fail_output"
    fi
}
