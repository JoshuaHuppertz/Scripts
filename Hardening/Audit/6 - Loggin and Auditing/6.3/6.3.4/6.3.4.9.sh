#!/usr/bin/env bash

check_audit_tool_ownership() {
    echo "Checking ownership of audit tools..."

    l_output=""
    a_audit_tools=("/sbin/auditctl" "/sbin/aureport" "/sbin/ausearch" "/sbin/autrace" "/sbin/auditd" "/sbin/augenrules")

    for l_audit_tool in "${a_audit_tools[@]}"; do
        if [ -e "$l_audit_tool" ]; then
            l_owner="$(stat -Lc "%U" "$l_audit_tool")"
            if [ "$l_owner" != "root" ]; then
                l_output="$l_output\n - Audit tool \"$l_audit_tool\" is owned by user: \"$l_owner\" (should be owned by user: \"root\")"
            fi
        else
            l_output="$l_output\n - Audit tool \"$l_audit_tool\" does not exist."
        fi
    done

    if [ -z "$l_output" ]; then
        echo -e "\n- Audit Result:\n ** PASS **\n - All audit tools are owned by user: \"root\""
    else
        echo -e "\n- Audit Result:\n ** FAIL **\n - * Reasons for audit failure * :$l_output\n"
    fi
}

# Run the check
check_audit_tool_ownership
