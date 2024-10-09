#!/usr/bin/env bash

check_installation() {
    local package="$1"
    dpkg-query -s "$package" &>/dev/null
    if [ $? -eq 0 ]; then
        echo "$package is installed"
        return 0
    else
        echo "$package is not installed"
        return 1
    fi
}

audit_results() {
    local package1="auditd"
    local package2="audispd-plugins"

    echo -e "\n- Audit Results:"
    
    if check_installation "$package1"; then
        l_output1="** PASS **: $package1 is installed."
    else
        l_output1="** FAIL **: $package1 is not installed."
    fi

    if check_installation "$package2"; then
        l_output2="** PASS **: $package2 is installed."
    else
        l_output2="** FAIL **: $package2 is not installed."
    fi

    echo -e "$l_output1\n$l_output2\n"
}

# Run the audit
audit_results
