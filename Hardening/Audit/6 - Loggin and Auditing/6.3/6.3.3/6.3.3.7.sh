#!/usr/bin/env bash

check_on_disk_rules() {
    echo "Checking on-disk audit rules for file access operations..."

    UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)
    if [ -n "${UID_MIN}" ]; then
        if awk "/^ *-a *always,exit/ \
            &&/ -F *arch=b(32|64)/ \
            &&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \
            &&/ -F *auid>=${UID_MIN}/ \
            &&(/ -F *exit=-EACCES/||/ -F *exit=-EPERM/) \
            &&/ -S/ \
            &&/creat/ \
            &&/open/ \
            &&/truncate/ \
            &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)" /etc/audit/rules.d/*.rules; then
            echo "OK: On-disk rules are correctly set."
        else
            echo "FAIL: On-disk rules are not set correctly."
            return 1  # Fail
        fi
    else
        echo "ERROR: Variable 'UID_MIN' is unset."
        return 1  # Fail
    fi
    return 0  # Pass
}

check_running_rules() {
    echo "Checking currently loaded audit rules for file access operations..."

    UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)
    if [ -n "${UID_MIN}" ]; then
        if auditctl -l | awk "/^ *-a *always,exit/ \
            &&/ -F *arch=b(32|64)/ \
            &&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \
            &&/ -F *auid>=${UID_MIN}/ \
            &&(/ -F *exit=-EACCES/||/ -F *exit=-EPERM/) \
            &&/ -S/ \
            &&/creat/ \
            &&/open/ \
            &&/truncate/ \
            &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)"; then
            echo "OK: Loaded rules are correctly set."
        else
            echo "FAIL: Loaded rules are not set correctly."
            return 1  # Fail
        fi
    else
        echo "ERROR: Variable 'UID_MIN' is unset."
        return 1  # Fail
    fi
    return 0  # Pass
}

audit_results() {
    echo -e "\n- Audit Results:"

    if check_on_disk_rules; then
        echo "** PASS **: On-disk audit rules for file access operations are set correctly."
    else
        echo "** FAIL **: On-disk audit rules for file access operations are not set correctly."
    fi

    if check_running_rules; then
        echo "** PASS **: Currently loaded audit rules for file access operations are set correctly."
    else
        echo "** FAIL **: Currently loaded audit rules for file access operations are not set correctly."
    fi
}

# Run the audit
audit_results
