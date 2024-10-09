#!/usr/bin/env bash

check_grub_audit_param() {
    # Finde die grub.cfg Datei und suche nach 'linux' Zeilen ohne 'audit=1'
    audit_check=$(find /boot -type f -name 'grub.cfg' -exec grep -Ph -- '^\h*linux' {} + | grep -v 'audit=1')

    # Überprüfe, ob die Ausgabe leer ist
    if [[ -z "$audit_check" ]]; then
        echo "No 'audit=1' parameter found in grub.cfg."
        return 0  # Pass
    else
        echo "'audit=1' parameter is present in grub.cfg."
        echo "$audit_check"  # Ausgabe der problematischen Zeilen
        return 1  # Fail
    fi
}

audit_results() {
    echo -e "\n- Audit Results:"
    if check_grub_audit_param; then
        echo "** PASS **: No 'audit=1' parameter found."
    else
        echo "** FAIL **: 'audit=1' parameter is present."
    fi
}

# Run the audit
audit_results
