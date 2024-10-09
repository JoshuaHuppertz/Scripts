#!/usr/bin/env bash

# Function to check for weak Key Exchange algorithms
check_weak_kex_algorithms() {
    local output
    output=$(sshd -T | grep -Pi -- 'kexalgorithms\h+([^#\n\r]+,)?(diffie-hellman-group1-sha1|diffie-hellman-group14-sha1|diffie-hellman-group-exchange-sha1)\b')

    # Check if any weak algorithms are found
    if [[ -z "$output" ]]; then
        echo -e "\n- Audit Result:\n ** PASS **\n - No weak Key Exchange algorithms are configured."
    else
        echo -e "\n- Audit Result:\n ** FAIL **\n - Weak Key Exchange algorithms found:\n$output"
    fi
}

# Main script execution
check_weak_kex_algorithms  # Check for weak Key Exchange algorithms
