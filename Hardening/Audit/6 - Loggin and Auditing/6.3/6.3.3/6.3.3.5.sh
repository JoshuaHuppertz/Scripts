#!/usr/bin/env bash

check_on_disk_rules() {
    echo "Checking on-disk audit rules for system locale changes..."

    # Check for the on-disk rules
    output1=$(awk '/^ *-a *always,exit/ \
    &&/ -F *arch=b(32|64)/ \
    &&/ -S/ \
    &&(/sethostname/ \
    ||/setdomainname/) \
    &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules)

    output2=$(awk '/^ *-w/ \
    &&(/\/etc\/issue/ \
    ||/\/etc\/issue.net/ \
    ||/\/etc\/hosts/ \
    ||/\/etc\/network/ \
    ||/\/etc\/netplan/) \
    &&/ +-p *wa/ \
    &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules)

    # Expected outputs
    expected_output1_b64="-a always,exit -F arch=b64 -S sethostname,setdomainname -k system-locale"
    expected_output1_b32="-a always,exit -F arch=b32 -S sethostname,setdomainname -k system-locale"
    expected_output2_w1="-w /etc/issue -p wa -k system-locale"
    expected_output2_w2="-w /etc/issue.net -p wa -k system-locale"
    expected_output2_w3="-w /etc/hosts -p wa -k system-locale"
    expected_output2_w4="-w /etc/network -p wa -k system-locale"
    expected_output2_w5="-w /etc/netplan -p wa -k system-locale"

    # Validate the outputs
    if [[ "$output1" == *"$expected_output1_b64"* && "$output1" == *"$expected_output1_b32"* && \
         "$output2" == *"$expected_output2_w1"* && "$output2" == *"$expected_output2_w2"* && \
         "$output2" == *"$expected_output2_w3"* && "$output2" == *"$expected_output2_w4"* && \
         "$output2" == *"$expected_output2_w5"* ]]; then
        echo "On-disk rules are configured correctly."
        return 0  # Pass
    else
        echo "On-disk rules are missing or incorrectly configured."
        echo "$output1"
        echo "$output2"
        return 1  # Fail
    fi
}

check_running_rules() {
    echo "Checking currently loaded audit rules for system locale changes..."

    # Check for the currently loaded rules
    output1=$(auditctl -l | awk '/^ *-a *always,exit/ \
    &&/ -F *arch=b(32|64)/ \
    &&/ -S/ \
    &&(/sethostname/ \
    ||/setdomainname/) \
    &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)')

    output2=$(auditctl -l | awk '/^ *-w/ \
    &&(/\/etc\/issue/ \
    ||/\/etc\/issue.net/ \
    ||/\/etc\/hosts/ \
    ||/\/etc\/network/ \
    ||/\/etc\/netplan/) \
    &&/ +-p *wa/ \
    &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)')

    # Expected outputs
    expected_output1_b64="-a always,exit -F arch=b64 -S sethostname,setdomainname -F key=system-locale"
    expected_output1_b32="-a always,exit -F arch=b32 -S sethostname,setdomainname -F key=system-locale"
    expected_output2_w1="-w /etc/issue -p wa -k system-locale"
    expected_output2_w2="-w /etc/issue.net -p wa -k system-locale"
    expected_output2_w3="-w /etc/hosts -p wa -k system-locale"
    expected_output2_w4="-w /etc/network -p wa -k system-locale"
    expected_output2_w5="-w /etc/netplan -p wa -k system-locale"

    # Validate the outputs
    if [[ "$output1" == *"$expected_output1_b64"* && "$output1" == *"$expected_output1_b32"* && \
         "$output2" == *"$expected_output2_w1"* && "$output2" == *"$expected_output2_w2"* && \
         "$output2" == *"$expected_output2_w3"* && "$output2" == *"$expected_output2_w4"* && \
         "$output2" == *"$expected_output2_w5"* ]]; then
        echo "Currently loaded rules are configured correctly."
        return 0  # Pass
    else
        echo "Currently loaded rules are missing or incorrectly configured."
        echo "$output1"
        echo "$output2"
        return 1  # Fail
    fi
}

audit_results() {
    echo -e "\n- Audit Results:"
    
    if check_on_disk_rules; then
        echo "** PASS **: On-disk audit rules for system locale are set correctly."
    else
        echo "** FAIL **: On-disk audit rules for system locale are not set correctly."
    fi

    if check_running_rules; then
        echo "** PASS **: Currently loaded audit rules for system locale are set correctly."
    else
        echo "** FAIL **: Currently loaded audit rules for system locale are not set correctly."
    fi
}

# Run the audit
audit_results
