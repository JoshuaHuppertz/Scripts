#!/usr/bin/env bash

check_space_left_action() {
    # Überprüfe, ob space_left_action auf email, exec, single oder halt gesetzt ist
    space_left_action_check=$(grep -Pi '^\h*space_left_action\h*=\h*(email|exec|single|halt)\b' /etc/audit/auditd.conf)
    
    if [[ -n "$space_left_action_check" ]]; then
        echo "Found space_left_action setting: $space_left_action_check"
        return 0  # Pass
    else
        echo "space_left_action parameter is missing or set incorrectly."
        return 1  # Fail
    fi
}

check_admin_space_left_action() {
    # Überprüfe, ob admin_space_left_action auf single oder halt gesetzt ist
    admin_space_left_action_check=$(grep -Pi '^\h*admin_space_left_action\h*=\h*(single|halt)\b' /etc/audit/auditd.conf)

    if [[ -n "$admin_space_left_action_check" ]]; then
        echo "Found admin_space_left_action setting: $admin_space_left_action_check"
        return 0  # Pass
    else
        echo "admin_space_left_action parameter is missing or set incorrectly."
        return 1  # Fail
    fi
}

audit_results() {
    echo -e "\n- Audit Results:"
    
    if check_space_left_action; then
        echo "** PASS **: 'space_left_action' parameter is set correctly to 'email', 'exec', 'single', or 'halt'."
    else
        echo "** FAIL **: 'space_left_action' parameter is missing or not set to 'email', 'exec', 'single', or 'halt'."
    fi

    if check_admin_space_left_action; then
        echo "** PASS **: 'admin_space_left_action' parameter is set correctly to 'single' or 'halt'."
    else
        echo "** FAIL **: 'admin_space_left_action' parameter is missing or not set to 'single' or 'halt'."
    fi
    
    echo -e "\n** Note: A Mail Transfer Agent (MTA) must be installed and configured properly to set space_left_action = email. **"
}

# Run the audit
audit_results
