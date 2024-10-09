check_on_disk_rules() {
    echo "Checking on-disk audit rules for login files..."

    # Check on-disk rules
    ON_DISK_OUTPUT=$(awk '/^ *-w/ \
        &&(/\/var\/log\/lastlog/ \
        ||/\/var\/run\/faillock/) \
        &&/ +-p *wa/ \
        &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules)

    # Expected output
    EXPECTED_OUTPUT=$(cat <<EOF
-w /var/log/lastlog -p wa -k logins
-w /var/run/faillock -p wa -k logins
EOF
    )

    if [ "$ON_DISK_OUTPUT" == "$EXPECTED_OUTPUT" ]; then
        echo "OK: On-disk rules are correctly set."
    else
        echo "FAIL: On-disk rules are not set correctly."
        echo "Expected:"
        echo "$EXPECTED_OUTPUT"
        echo "Actual:"
        echo "$ON_DISK_OUTPUT"
        return 1  # Fail
    fi
    return 0  # Pass
}

check_running_rules() {
    echo "Checking currently loaded audit rules for login files..."

    # Check loaded rules
    RUNNING_OUTPUT=$(auditctl -l | awk '/^ *-w/ \
        &&(/\/var\/log\/lastlog/ \
        ||/\/var\/run\/faillock/) \
        &&/ +-p *wa/ \
        &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)')

    # Expected output
    EXPECTED_RUNNING_OUTPUT=$(cat <<EOF
-w /var/log/lastlog -p wa -k logins
-w /var/run/faillock -p wa -k logins
EOF
    )

    if [ "$RUNNING_OUTPUT" == "$EXPECTED_RUNNING_OUTPUT" ]; then
        echo "OK: Loaded rules are correctly set."
    else
        echo "FAIL: Loaded rules are not set correctly."
        echo "Expected:"
        echo "$EXPECTED_RUNNING_OUTPUT"
        echo "Actual:"
        echo "$RUNNING_OUTPUT"
        return 1  # Fail
    fi
    return 0  # Pass
}

# Execute the checks
check_on_disk_rules
check_running_rules
