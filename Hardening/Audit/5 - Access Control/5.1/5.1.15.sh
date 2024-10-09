#!/usr/bin/env bash

# Function to check for weak MAC algorithms
check_weak_macs() {
    local output
    local weak_macs_regex='macs\h+([^#\n\r]+,)?(hmac-md5|hmac-md5-96|hmac-ripemd160|hmac-sha1-96|umac-64@openssh\.com|hmac-md5-etm@openssh\.com|hmac-md5-96-etm@openssh\.com|hmac-ripemd160-etm@openssh\.com|hmac-sha1-96-etm@openssh\.com|umac-64-etm@openssh\.com|umac-128-etm@openssh\.com)\b'

    # Retrieve the MAC settings from the sshd configuration
    output=$(sshd -T | grep -Pi -- "$weak_macs_regex")

    # Check if any weak MACs are found
    if [[ -z "$output" ]]; then
        echo -e "\n- Audit Result:\n ** PASS **\n - No weak MAC algorithms are being used."
    else
        echo -e "\n- Audit Result:\n ** FAIL **\n - Weak MAC algorithms detected:\n$output"
        echo -e "\n- Note: Review CVE-2023-48795 and verify the system has been patched. If the system has not been patched, review the use of the Encrypt Then Mac (etm) MACs."
    fi
}

# Main script execution
check_weak_macs  # Check for weak MAC algorithms
