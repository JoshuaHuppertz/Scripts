#!/usr/bin/env bash

check_max_log_file() {
    # Suche nach max_log_file in der auditd.conf
    max_log_file_check=$(grep -Po -- '^\h*max_log_file\h*=\h*\d+\b' /etc/audit/auditd.conf)

    # Überprüfe, ob der Parameter gesetzt ist
    if [[ -n "$max_log_file_check" ]]; then
        echo "Found max_log_file setting: $max_log_file_check"
        return 0  # Pass
    else
        echo "max_log_file parameter is missing or not set correctly."
        return 1  # Fail
    fi
}

audit_results() {
    echo -e "\n- Audit Results:"
    if check_max_log_file; then
        echo "** PASS **: 'max_log_file' parameter is set correctly."
    else
        echo "** FAIL **: 'max_log_file' parameter is missing or not set correctly."
    fi
}

# Run the audit
audit_results
