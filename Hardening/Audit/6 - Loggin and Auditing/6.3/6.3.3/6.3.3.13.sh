check_on_disk_rules() {
    echo "Checking on-disk audit rules for delete operations..."

    # Get UID_MIN
    UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)
    if [ -n "${UID_MIN}" ]; then
        # Check on-disk rules
        ON_DISK_OUTPUT=$(awk "/^ *-a *always,exit/ \
            &&/ -F *arch=b(32|64)/ \
            &&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \
            &&/ -F *auid>=${UID_MIN}/ \
            &&/ -S/ \
            &&(/unlink/||/rename/||/unlinkat/||/renameat/) \
            &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)" /etc/audit/rules.d/*.rules)

        # Expected output
        EXPECTED_OUTPUT=$(cat <<EOF
-a always,exit -F arch=b64 -S unlink,unlinkat,rename,renameat -F auid>=1000 -F auid!=unset -k delete
-a always,exit -F arch=b32 -S unlink,unlinkat,rename,renameat -F auid>=1000 -F auid!=unset -k delete
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
    else
        echo "ERROR: Variable 'UID_MIN' is unset."
        return 1  # Fail
    fi
    return 0  # Pass
}

check_running_rules() {
    echo "Checking currently loaded audit rules for delete operations..."

    # Get UID_MIN
    UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)
    if [ -n "${UID_MIN}" ]; then
        # Check loaded rules
        RUNNING_OUTPUT=$(auditctl -l | awk "/^ *-a *always,exit/ \
            &&/ -F *arch=b(32|64)/ \
            &&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \
            &&/ -F *auid>=${UID_MIN}/ \
            &&/ -S/ \
            &&(/unlink/||/rename/||/unlinkat/||/renameat/) \
            &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)")

        # Expected output
        EXPECTED_RUNNING_OUTPUT=$(cat <<EOF
-a always,exit -F arch=b64 -S rename,unlink,unlinkat,renameat -F auid>=1000 -F auid!=-1 -F key=delete
-a always,exit -F arch=b32 -S unlink,rename,unlinkat,renameat -F auid>=1000 -F auid!=-1 -F key=delete
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
    else
        echo "ERROR: Variable 'UID_MIN' is unset."
        return 1  # Fail
    fi
    return 0  # Pass
}

# Execute the checks
check_on_disk_rules
check_running_rules
