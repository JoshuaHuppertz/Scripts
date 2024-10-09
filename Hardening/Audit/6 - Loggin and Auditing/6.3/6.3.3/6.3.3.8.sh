check_on_disk_rules() {
    echo "Checking on-disk audit rules for identity-related files..."

    # Check on-disk rules
    ON_DISK_OUTPUT=$(awk '/^ *-w/ \
        &&(/\/etc\/group/ \
        ||/\/etc\/passwd/ \
        ||/\/etc\/gshadow/ \
        ||/\/etc\/shadow/ \
        ||/\/etc\/security\/opasswd/ \
        ||/\/etc\/nsswitch.conf/ \
        ||/\/etc\/pam.conf/ \
        ||/\/etc\/pam.d/) \
        &&/ +-p *wa/ \
        &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules)

    # Expected output
    EXPECTED_OUTPUT=$(cat <<EOF
-w /etc/group -p wa -k identity
-w /etc/passwd -p wa -k identity
-w /etc/gshadow -p wa -k identity
-w /etc/shadow -p wa -k identity
-w /etc/security/opasswd -p wa -k identity
-w /etc/nsswitch.conf -p wa -k identity
-w /etc/pam.conf -p wa -k identity
-w /etc/pam.d -p wa -k identity
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
    echo "Checking currently loaded audit rules for identity-related files..."

    # Check loaded rules
    RUNNING_OUTPUT=$(auditctl -l | awk '/^ *-w/ \
        &&(/\/etc\/group/ \
        ||/\/etc\/passwd/ \
        ||/\/etc\/gshadow/ \
        ||/\/etc\/shadow/ \
        ||/\/etc\/security\/opasswd/ \
        ||/\/etc\/nsswitch.conf/ \
        ||/\/etc\/pam.conf/ \
        ||/\/etc\/pam.d/) \
        &&/ +-p *wa/ \
        &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)')

    if [ "$RUNNING_OUTPUT" == "$EXPECTED_OUTPUT" ]; then
        echo "OK: Loaded rules are correctly set."
    else
        echo "FAIL: Loaded rules are not set correctly."
        echo "Expected:"
        echo "$EXPECTED_OUTPUT"
        echo "Actual:"
        echo "$RUNNING_OUTPUT"
        return 1  # Fail
    fi
    return 0  # Pass
}

# Execute the checks
check_on_disk_rules
check_running_rules
