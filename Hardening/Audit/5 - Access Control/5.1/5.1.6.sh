#!/usr/bin/env bash

# Initialize output variables
output=""
weak_ciphers_pattern="^(3des|blowfish|cast128|aes(128|192|256))-cbc|arcfour(128|256)?|rijndael-cbc@lysator\.liu\.se"

# Function to check for weak ciphers in the SSHD configuration
check_weak_ciphers() {
    output=$(sshd -T | grep -Pi -- '^ciphers\h+"?([^#\n\r]+,)?'"$weak_ciphers_pattern"'\b')

    if [[ -n "$output" ]]; then
        echo -e "\n- Audit Result:\n ** FAIL **\n - Weak ciphers found in SSHD configuration:\n$output"
        
        # Check for chacha20-poly1305@openssh.com in the output
        if echo "$output" | grep -q 'chacha20-poly1305@openssh.com'; then
            echo -e "\n - The cipher 'chacha20-poly1305@openssh.com' is included. Please review CVE-2023-48795 and verify the system is patched."
        fi
    else
        echo -e "\n- Audit Result:\n ** PASS **\n - No weak ciphers found in SSHD configuration."
    fi
}

# Main script execution
check_weak_ciphers  # Check for weak ciphers
