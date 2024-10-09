#!/usr/bin/env bash

check_auditd_status() {
    local status_command="$1"
    local expected_status="$2"
    local service_name="$3"

    status_output=$(eval "$status_command" 2>/dev/null)
    if [[ "$status_output" == "$expected_status" ]]; then
        echo "$service_name is $expected_status"
        return 0
    else
        echo "$service_name is not $expected_status"
        return 1
    fi
}

audit_results() {
    local service_name="auditd"
    local enabled_status="enabled"
    local active_status="active"

    echo -e "\n- Audit Results:"

    if check_auditd_status "systemctl is-enabled $service_name | grep '^enabled'" "$enabled_status" "$service_name"; then
        enabled_output="** PASS **: $service_name is enabled."
    else
        enabled_output="** FAIL **: $service_name is not enabled."
    fi

    if check_auditd_status "systemctl is-active $service_name | grep '^active'" "$active_status" "$service_name"; then
        active_output="** PASS **: $service_name is active."
    else
        active_output="** FAIL **: $service_name is not active."
    fi

    echo -e "$enabled_output\n$active_output\n"
}

# Run the audit
audit_results
