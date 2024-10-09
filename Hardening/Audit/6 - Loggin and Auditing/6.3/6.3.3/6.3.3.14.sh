check_on_disk_rules() {
    echo "Checking on-disk audit rules for AppArmor..."

    # Check on-disk rules
    ON_DISK_OUTPUT=$(awk '/^ *-w/ \
        &&(/\/etc\/apparmor/ \
        ||/\/etc\/apparmor.d/) \
        &&/ +-p *wa/ \
        &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)' /etc/audit/rules.d/*.rules)

    # Expected output
    EXPECTED_OUTPUT=$(cat <<EOF
-w /etc/apparmor/ -p wa -k MAC-policy
-w /etc/apparmor.d/ -p wa -k MAC-policy
EOF
    )

    if [ "$ON_DISK_OUTPUT" == "$EXPECTED_OUTPUT" ]; then
        echo -e "\e[32mOK: On-disk rules for AppArmor are correctly set.\e[0m"
    else
        echo -e "\e[31mFAIL: On-disk rules for AppArmor are not set correctly.\e[0m"
        echo "Expected:"
        echo "$EXPECTED_OUTPUT"
        echo "Actual:"
        echo "$ON_DISK_OUTPUT"
        return 1  # Fail
    fi
    return 0  # Pass
}

check_running_rules() {
    echo "Checking currently loaded audit rules for AppArmor..."

    # Check loaded rules
    RUNNING_OUTPUT=$(auditctl -l | awk '/^ *-w/ \
        &&(/\/etc\/apparmor/ \
        ||/\/etc\/apparmor.d/) \
        &&/ +-p *wa/ \
        &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)')

    # Expected output
    EXPECTED_RUNNING_OUTPUT=$(cat <<EOF
-w /etc/apparmor/ -p wa -k MAC-policy
-w /etc/apparmor.d/ -p wa -k MAC-policy
EOF
    )

    if [ "$RUNNING_OUTPUT" == "$EXPECTED_RUNNING_OUTPUT" ]; then
        echo -e "\e[32mOK: Loaded rules for AppArmor are correctly set.\e[0m"
    else
        echo -e "\e[31mFAIL: Loaded rules for AppArmor are not set correctly.\e[0m"
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
