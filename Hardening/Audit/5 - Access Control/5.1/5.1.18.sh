#!/usr/bin/env bash

# Function to check MaxStartups
check_max_startups() {
    local output

    # Retrieve MaxStartups setting from the sshd configuration
    output=$(sshd -T | awk '$1 ~ /^\s*maxstartups{print $2}')

    # Check if output is not empty
    if [[ -n "$output" ]]; then
        # Split the MaxStartups value into parts
        IFS=':' read -r max_conn min_conn max_conn_rate <<< "$output"
        
        # Validate against the allowed limits
        if (( max_conn > 10 || min_conn > 30 || max_conn_rate > 60 )); then
            echo -e "\n- Audit Result:\n ** FAIL **\n - MaxStartups is set to $output (greater than 10:30:60)."
        else
            echo -e "\n- Audit Result:\n ** PASS **\n - MaxStartups is set to $output (10:30:60 or more restrictive)."
        fi
    else
        echo -e "\n- Audit Result:\n ** FAIL **\n - MaxStartups is not set."
    fi
}

# Main script execution
check_max_startups  # Check MaxStartups
