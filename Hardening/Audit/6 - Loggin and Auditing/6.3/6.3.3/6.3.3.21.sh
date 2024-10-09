check_audit_rule_merge() {
    echo "Checking merged rule sets..."

    # Run the augenrules check
    MERGE_OUTPUT=$(/usr/sbin/augenrules --check 2>&1)

    # Check for expected output
    if [[ "$MERGE_OUTPUT" == *"No change"* ]]; then
        echo "PASS: All rules have been successfully merged into /etc/audit/audit.rules."
    else
        echo "FAIL: There are discrepancies in the merged rule sets."
        echo "Output: $MERGE_OUTPUT"
        echo "You may need to run: augenrules --load to merge and load all rules."
    fi
}

check_audit_rule_merge
