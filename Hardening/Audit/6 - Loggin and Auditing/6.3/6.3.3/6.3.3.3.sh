#!/usr/bin/env bash

check_sudo_log_file() {
    echo "Checking for sudo log file configuration..."
    SUDO_LOG_FILE=$(grep -r 'logfile' /etc/sudoers* | sed -e 's/.*logfile=//;s/,.*//' -e 's/"//g')
    
    if [ -z "$SUDO_LOG_FILE" ]; then
        echo "ERROR: Variable 'SUDO_LOG_FILE' is unset."
        return 1  # Fail
    fi

    echo "SUDO_LOG_FILE found: $SUDO_LOG_FILE"
    return 0  # Pass
}

check_on_disk_rules() {
    echo "Checking on-disk audit rules for sudo log file..."
    
    if check_sudo_log_file; then
        output=$(awk "/^ *-w/ && /${SUDO_LOG_FILE//\//\\/}/ && /-p *wa/ && (/ key= *[!-~]* *$/ || / -k *[!-~]* *$/)" /etc/audit/rules.d/*.rules)

        if [[ "$output" == *"-w ${SUDO_LOG_FILE} -p wa -k sudo_log_file"* ]]; then
            echo "On-disk rules are configured correctly."
            return 0  # Pass
        else
            echo "On-disk rules are missing or incorrectly configured."
            echo "$output"
            return 1  # Fail
        fi
    else
        return 1  # Fail
    fi
}

check_running_rules() {
    echo "Checking currently loaded audit rules for sudo log file..."

    if check_sudo_log_file; then
        output=$(auditctl -l | awk "/^ *-w/ && /${SUDO_LOG_FILE//\//\\/}/ && /-p *wa/ && (/ key= *[!-~]* *$/ || / -k *[!-~]* *$/)")

        if [[ "$output" == *"-w ${SUDO_LOG_FILE} -p wa -k sudo_log_file"* ]]; then
            echo "Running rules are configured correctly."
            return 0  # Pass
        else
            echo "Running rules are missing or incorrectly configured."
            echo "$output"
            return 1  # Fail
        fi
    else
        return 1  # Fail
    fi
}

audit_results() {
    echo -e "\n- Audit Results:"
    
    if check_on_disk_rules; then
        echo "** PASS **: On-disk audit rules for sudo log file are set correctly."
    else
        echo "** FAIL **: On-disk audit rules for sudo log file are not set correctly."
    fi

    if check_running_rules; then
        echo "** PASS **: Currently loaded audit rules for sudo log file are set correctly."
    else
        echo "** FAIL **: Currently loaded audit rules for sudo log file are not set correctly."
    fi
}

# Run the audit
audit_results
