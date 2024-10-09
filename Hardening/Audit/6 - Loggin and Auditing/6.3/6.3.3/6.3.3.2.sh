#!/usr/bin/env bash

check_on_disk_rules() {
    echo "Checking on-disk rules for user emulation..."
    on_disk_output=$(awk '/^ *-a *always,exit/ \
        && / -F *arch=b(32|64)/ \
        && (/ -F *auid!=unset/ || / -F *auid!=-1/ || / -F *auid!=4294967295/) \
        && (/ -C *euid!=uid/ || / -C *uid!=euid/) \
        && / -S *execve/ \
        && (/ key= *[!-~]* *$/ || / -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules)

    if [[ "$on_disk_output" == *"-a always,exit -F arch=b64 -C euid!=uid -F auid!=unset -S execve -k user_emulation"* ]] && \
       [[ "$on_disk_output" == *"-a always,exit -F arch=b32 -C euid!=uid -F auid!=unset -S execve -k user_emulation"* ]]; then
        echo "On-disk rules are configured correctly."
        return 0  # Pass
    else
        echo "On-disk rules are missing or incorrectly configured."
        echo "$on_disk_output"
        return 1  # Fail
    fi
}

check_running_rules() {
    echo "Checking running rules for user emulation..."
    running_output=$(auditctl -l | awk '/^ *-a *always,exit/ \
        && / -F *arch=b(32|64)/ \
        && (/ -F *auid!=unset/ || / -F *auid!=-1/ || / -F *auid!=4294967295/) \
        && (/ -C *euid!=uid/ || / -C *uid!=euid/) \
        && / -S *execve/ \
        && (/ key= *[!-~]* *$/ || / -k *[!-~]* *$/)')

    if [[ "$running_output" == *"-a always,exit -F arch=b64 -S execve -C uid!=euid -F auid!=-1 -F key=user_emulation"* ]] && \
       [[ "$running_output" == *"-a always,exit -F arch=b32 -S execve -C uid!=euid -F auid!=-1 -F key=user_emulation"* ]]; then
        echo "Running rules are configured correctly."
        return 0  # Pass
    else
        echo "Running rules are missing or incorrectly configured."
        echo "$running_output"
        return 1  # Fail
    fi
}

audit_results() {
    echo -e "\n- Audit Results:"
    
    if check_on_disk_rules; then
        echo "** PASS **: On-disk rules for user emulation are set correctly."
    else
        echo "** FAIL **: On-disk rules for user emulation are not set correctly."
    fi

    if check_running_rules; then
        echo "** PASS **: Running rules for user emulation are set correctly."
    else
        echo "** FAIL **: Running rules for user emulation are not set correctly."
    fi
}

# Run the audit
audit_results
