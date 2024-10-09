#!/usr/bin/env bash

check_on_disk_rules() {
    echo "Checking on-disk rules for /etc/sudoers..."
    on_disk_output=$(awk '/^ *-w/ && /\/etc\/sudoers/ && / -p *wa/ && (/ key= *[!-~]* *$/ || / -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules)

    if [[ "$on_disk_output" == *"-w /etc/sudoers -p wa -k scope"* ]] && [[ "$on_disk_output" == *"-w /etc/sudoers.d -p wa -k scope"* ]]; then
        echo "On-disk rules are configured correctly."
        return 0  # Pass
    else
        echo "On-disk rules are missing or incorrectly configured."
        echo "$on_disk_output"
        return 1  # Fail
    fi
}

check_running_rules() {
    echo "Checking running rules for /etc/sudoers..."
    running_output=$(auditctl -l | awk '/^ *-w/ && /\/etc\/sudoers/ && / -p *wa/ && (/ key= *[!-~]* *$/ || / -k *[!-~]* *$/)')

    if [[ "$running_output" == *"-w /etc/sudoers -p wa -k scope"* ]] && [[ "$running_output" == *"-w /etc/sudoers.d -p wa -k scope"* ]]; then
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
        echo "** PASS **: On-disk rules for /etc/sudoers are set correctly."
    else
        echo "** FAIL **: On-disk rules for /etc/sudoers are not set correctly."
    fi

    if check_running_rules; then
        echo "** PASS **: Running rules for /etc/sudoers are set correctly."
    else
        echo "** FAIL **: Running rules for /etc/sudoers are not set correctly."
    fi
}

# Run the audit
audit_results
