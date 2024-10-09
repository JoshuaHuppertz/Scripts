#!/usr/bin/env bash

check_on_disk_rules() {
    echo "Checking on-disk audit rules for privileged files..."

    for PARTITION in $(findmnt -n -l -k -it $(awk '/nodev/ { print $2 }' /proc/filesystems | paste -sd,) | grep -Pv "noexec|nosuid" | awk '{print $1}'); do
        for PRIVILEGED in $(find "${PARTITION}" -xdev -perm /6000 -type f); do
            if grep -qr "${PRIVILEGED}" /etc/audit/rules.d; then
                echo "OK: '${PRIVILEGED}' found in auditing rules."
            else
                echo "Warning: '${PRIVILEGED}' not found in on-disk configuration."
                return 1  # Fail
            fi
        done
    done
    return 0  # Pass
}

check_running_rules() {
    echo "Checking currently loaded audit rules for privileged files..."

    RUNNING=$(auditctl -l)
    if [ -n "${RUNNING}" ]; then
        for PARTITION in $(findmnt -n -l -k -it $(awk '/nodev/ { print $2 }' /proc/filesystems | paste -sd,) | grep -Pv "noexec|nosuid" | awk '{print $1}'); do
            for PRIVILEGED in $(find "${PARTITION}" -xdev -perm /6000 -type f); do
                if printf -- "${RUNNING}" | grep -q "${PRIVILEGED}"; then
                    echo "OK: '${PRIVILEGED}' found in auditing rules."
                else
                    echo "Warning: '${PRIVILEGED}' not found in running configuration."
                    return 1  # Fail
                fi
            done
        done
    else
        echo "ERROR: Variable 'RUNNING' is unset."
        return 1  # Fail
    fi
    return 0  # Pass
}

audit_results() {
    echo -e "\n- Audit Results:"

    if check_on_disk_rules; then
        echo "** PASS **: On-disk audit rules for privileged files are set correctly."
    else
        echo "** FAIL **: On-disk audit rules for privileged files are not set correctly."
    fi

    if check_running_rules; then
        echo "** PASS **: Currently loaded audit rules for privileged files are set correctly."
    else
        echo "** FAIL **: Currently loaded audit rules for privileged files are not set correctly."
    fi
}

# Run the audit
audit_results
