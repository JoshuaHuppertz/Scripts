check_kmod_audit_rules() {
    echo "Checking on-disk audit rules for kernel modules..."

    # On-disk configuration check for kernel module audit rules
    UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)
    if [ -n "${UID_MIN}" ]; then
        ON_DISK_KERNEL_MODULES_OUTPUT=$(awk "/^ *-a *always,exit/ \
            &&/ -F *arch=b(32|64)/ \
            &&(/ -F auid!=unset/||/ -F auid!=-1/||/ -F auid!=4294967295/) \
            &&/ -S/ \
            &&(/init_module/||/finit_module/||/delete_module/) \
            &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)" /etc/audit/rules.d/*.rules)

        ON_DISK_KMOD_OUTPUT=$(awk "/^ *-a *always,exit/ \
            &&/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/ \
            &&/ -F *auid>=${UID_MIN}/ \
            &&/ -F *perm=x/ \
            &&/ -F *path=\/usr\/bin\/kmod/ \
            &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)" /etc/audit/rules.d/*.rules)

        # Validate output
        if [[ "$ON_DISK_KERNEL_MODULES_OUTPUT" == *"-F arch=b64 -S init_module,finit_module,delete_module -F auid>=1000 -F auid!=unset -k kernel_modules"* ]] &&
           [[ "$ON_DISK_KMOD_OUTPUT" == *"-F path=/usr/bin/kmod -F perm=x -F auid>=1000 -F auid!=unset -k kernel_modules"* ]]; then
            echo "PASS: On-disk rules for kernel modules are correctly set."
        else
            echo "FAIL: On-disk rules for kernel modules are not set correctly."
        fi
    else
        echo "ERROR: Variable 'UID_MIN' is unset."
        return 1
    fi

    echo "Checking running audit rules for kernel modules..."

    # Running configuration check for kernel module audit rules
    RUNNING_KERNEL_MODULES_OUTPUT=$(auditctl -l | awk "/^ *-a *always,exit/ \
        &&/ -F *arch=b(32|64)/ \
        &&(/ -F auid!=unset/||/ -F auid!=-1/||/ -F auid!=4294967295/) \
        &&/ -S/ \
        &&(/init_module/||/finit_module/||/delete_module/) \
        &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)")

    RUNNING_KMOD_OUTPUT=$(auditctl -l | awk "/^ *-a *always,exit/ \
        &&(/ -F *auid!=unset/||/ -F *auid!=-1/||/ -F *auid!=4294967295/) \
        &&/ -F *auid>=${UID_MIN}/ \
        &&/ -F *perm=x/ \
        &&/ -F *path=\/usr\/bin\/kmod/ \
        &&(/ key= *[!-~]* *$/||/ -k *[!-~]* *$/)")

    # Validate output
    if [[ "$RUNNING_KERNEL_MODULES_OUTPUT" == *"-F arch=b64 -S init_module,finit_module,delete_module -F auid>=1000 -F auid!=-1 -F key=kernel_modules"* ]] &&
       [[ "$RUNNING_KMOD_OUTPUT" == *"-F path=/usr/bin/kmod -F perm=x -F auid>=1000 -F auid!=-1 -F key=kernel_modules"* ]]; then
        echo "PASS: Running rules for kernel modules are correctly set."
    else
        echo "FAIL: Running rules for kernel modules are not set correctly."
    fi

    echo "Checking symlinks for kmod..."

    # Symlink audit
    S_LINKS=$(ls -l /usr/sbin/lsmod /usr/sbin/rmmod /usr/sbin/insmod /usr/sbin/modinfo /usr/sbin/modprobe /usr/sbin/depmod | grep -vE " -> (\.\./)?bin/kmod" || true)
    if [[ "${S_LINKS}" != "" ]]; then
        echo "FAIL: Issue with symlinks: ${S_LINKS}"
    else
        echo "PASS: Symlinks for kmod are correct."
    fi
}

check_kmod_audit_rules
