#!/usr/bin/env bash

{
    # Initialize output variables
    l_fail_output=""
    
    # Check for duplicate UIDs
    while read -r l_count l_uid; do
        if [ "$l_count" -gt 1 ]; then
            # Collect duplicate UID information
            l_fail_output+="Duplicate UID: \"$l_uid\" Users: \"$(awk -F: '($3 == n) {print $1 }' n=$l_uid /etc/passwd | xargs)\"\n"
        fi
    done < <(cut -f3 -d":" /etc/passwd | sort -n | uniq -c)

    # Check if there were any duplicate UIDs found
    if [ -z "$l_fail_output" ]; then
        echo -e "\n- Audit Result:\n ** PASS **\n - * No duplicate UIDs found in /etc/passwd. *\n"
    else
        echo -e "\n- Audit Result:\n ** FAIL **\n - * Duplicate UIDs found: *\n$l_fail_output"
    fi
}
