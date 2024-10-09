#!/usr/bin/env bash

{
    # Run the awk command to check for users without passwords
    output=$(awk -F: '($2 == "") { print $1 " does not have a password." }' /etc/shadow)

    # Check if the output is empty
    if [ -z "$output" ]; then
        # If no output, the test has passed
        echo -e "\n- Audit Result:\n ** PASS **\n - * All users have passwords set correctly. *\n"
    else
        # If there is output, the test has failed
        echo -e "\n- Audit Result:\n ** FAIL **\n - * Users without passwords detected: *\n$output\n"
    fi
}
