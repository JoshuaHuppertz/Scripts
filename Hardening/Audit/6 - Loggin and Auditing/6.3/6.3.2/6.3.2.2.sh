#!/usr/bin/env bash

check_max_log_file_action() {
    # Suche nach max_log_file_action in der auditd.conf
    max_log_file_action_check=$(grep -Po '^\h*max_log_file_action\h*=\h*\w+' /etc/audit/auditd.conf)

    # Überprüfe, ob der Parameter gesetzt ist und ob er den erwarteten Wert hat
    if [[ "$max_log_file_action_check" == "max_log_file_action = keep_logs" ]]; then
        echo "Found max_log_file_action setting: $max_log_file_action_check"
        return 0  # Pass
    else
        echo "max_log_file_action parameter is missing or set incorrectly."
        return 1  # Fail
    fi
}

audit_results() {
    echo -e "\n- Audit Results:"
    if check_max_log_file_action; then
        echo "** PASS **: 'max_log_file_action' parameter is set correctly to 'keep_logs'."
    else
        echo "** FAIL **: 'max_log_file_action' parameter is missing or not set to 'keep_logs'."
    fi
}

# Run the audit
audit_results
