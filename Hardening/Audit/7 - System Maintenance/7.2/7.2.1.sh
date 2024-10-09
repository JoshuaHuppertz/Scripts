#!/usr/bin/env bash

{
    # Run the awk command to check for users not set to shadowed passwords
    output=$(awk -F: '($2 != "x") { print "User: \"" $1 "\" is not set to shadowed passwords." }' /etc/passwd)

    # Check if the output is empty
    if [ -z "$output" ]; then
        # If no output, the test has passed
        echo -e "\n- Audit Result:\n ** PASS **\n - * All users are correctly configured with shadowed passwords. *\n"
    else
        # If there is output, the test has failed
        echo -e "\n- Audit Result:\n ** FAIL **\n - * Users without shadowed passwords detected: *\n$output\n"
    fi
}
