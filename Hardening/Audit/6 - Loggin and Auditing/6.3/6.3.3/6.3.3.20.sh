check_audit_logging_level() {
    echo "Checking audit logging level..."

    # Check the audit logging level
    LOGGING_LEVEL_OUTPUT=$(grep -Ph -- '^\h*-e\h+2\b' /etc/audit/rules.d/*.rules | tail -1)

    # Validate output
    if [[ "$LOGGING_LEVEL_OUTPUT" == "-e 2" ]]; then
        echo "PASS: Audit logging level is set to 2."
    else
        echo "FAIL: Audit logging level is not set to 2."
        echo "Output: ${LOGGING_LEVEL_OUTPUT}"
    fi
}

check_audit_logging_level
