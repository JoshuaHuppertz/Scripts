#!/usr/bin/env bash

check_disk_full_action() {
    # Überprüfe, ob disk_full_action auf halt oder single gesetzt ist
    disk_full_action_check=$(grep -Pi '^\h*disk_full_action\h*=\h*(halt|single)\b' /etc/audit/auditd.conf)
    
    if [[ -n "$disk_full_action_check" ]]; then
        echo "Found disk_full_action setting: $disk_full_action_check"
        return 0  # Pass
    else
        echo "disk_full_action parameter is missing or set incorrectly."
        return 1  # Fail
    fi
}

check_disk_error_action() {
    # Überprüfe, ob disk_error_action auf syslog, single oder halt gesetzt ist
    disk_error_action_check=$(grep -Pi '^\h*disk_error_action\h*=\h*(syslog|single|halt)\b' /etc/audit/auditd.conf)

    if [[ -n "$disk_error_action_check" ]]; then
        echo "Found disk_error_action setting: $disk_error_action_check"
        return 0  # Pass
    else
        echo "disk_error_action parameter is missing or set incorrectly."
        return 1  # Fail
    fi
}

audit_results() {
    echo -e "\n- Audit Results:"
    
    if check_disk_full_action; then
        echo "** PASS **: 'disk_full_action' parameter is set correctly to 'halt' or 'single'."
    else
        echo "** FAIL **: 'disk_full_action' parameter is missing or not set to 'halt' or 'single'."
    fi

    if check_disk_error_action; then
        echo "** PASS **: 'disk_error_action' parameter is set correctly to 'syslog', 'single', or 'halt'."
    else
        echo "** FAIL **: 'disk_error_action' parameter is missing or not set to 'syslog', 'single', or 'halt'."
    fi
}

# Run the audit
audit_results
