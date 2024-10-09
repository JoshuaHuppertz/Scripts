check_usermod_audit_rules() {
    echo "Checking on-disk audit rules for /usr/sbin/usermod..."

    UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)
    if [ -n "${UID_MIN}" ]; then
        ON_DISK_OUTPUT=$(awk "/^ *-a *always,exit/ \
            &&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \
            &&/ -F *auid>=${UID_MIN}/ \
            &&/ -F *perm=x/ \
            &&/ -F *path=\/usr\/sbin\/usermod/ \
            &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)" /etc/audit/rules.d/*.rules)

        if [[ "$ON_DISK_OUTPUT" == *"-F path=/usr/sbin/usermod -F perm=x -F auid>=1000 -F auid!=unset -k usermod"* ]]; then
            echo "PASS: On-disk rules are correctly set."
        else
            echo "FAIL: On-disk rules are not set correctly."
        fi
    else
        echo "ERROR: Variable 'UID_MIN' is unset."
        return 1
    fi

    echo "Checking running audit rules for /usr/sbin/usermod..."

    RUNNING_OUTPUT=$(auditctl -l | awk "/^ *-a *always,exit/ \
        &&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \
        &&/ -F *auid>=${UID_MIN}/ \
        &&/ -F *perm=x/ \
        &&/ -F *path=\/usr\/sbin\/usermod/ \
        &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)")

    if [[ "$RUNNING_OUTPUT" == *"-F path=/usr/sbin/usermod -F perm=x -F auid>=1000 -F auid!=-1 -F key=usermod"* ]]; then
        echo "PASS: Running rules are correctly set."
    else
        echo "FAIL: Running rules are not set correctly."
    fi
}

check_usermod_audit_rules
