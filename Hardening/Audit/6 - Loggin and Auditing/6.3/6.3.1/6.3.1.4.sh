#!/usr/bin/env bash

check_audit_backlog_limit() {
    # Finde die grub.cfg Datei und suche nach 'linux' Zeilen ohne 'audit_backlog_limit='
    audit_check=$(find /boot -type f -name 'grub.cfg' -exec grep -Ph -- '^\h*linux' {} + | grep -Pv 'audit_backlog_limit=\d+\b')

    # Überprüfe, ob die Ausgabe leer ist
    if [[ -z "$audit_check" ]]; then
        echo "The 'audit_backlog_limit=' parameter is correctly set."
        return 0  # Pass
    else
        echo "'audit_backlog_limit=' parameter is missing or incorrectly set."
        echo "$audit_check"  # Ausgabe der problematischen Zeilen
        return 1  # Fail
    fi
}

audit_results() {
    echo -e "\n- Audit Results:"
    if check_audit_backlog_limit; then
        echo "** PASS **: 'audit_backlog_limit=' parameter is set."
    else
        echo "** FAIL **: 'audit_backlog_limit=' parameter is missing."
    fi
}

# Run the audit
audit_results
