#!/usr/bin/env bash

check_log_group() {
    echo "Checking log_group parameter in /etc/audit/auditd.conf..."

    if grep -Piws -- '^\h*log_group\h*=\h*\H+\b' /etc/audit/auditd.conf | grep -Pvi -- '(adm)'; then
        echo -e "\n- Audit Result:\n ** FAIL **\n - log_group parameter should be set to 'adm' or 'root'."
    else
        echo -e "\n- Audit Result:\n ** PASS **\n - log_group parameter is correctly set."
    fi
}

check_audit_log_ownership() {
    echo "Checking ownership of audit log files..."

    if [ -e /etc/audit/auditd.conf ]; then
        l_fpath="$(dirname "$(awk -F "=" '/^\s*log_file/ {print $2}' /etc/audit/auditd.conf | xargs)")"
        l_invalid_files=$(find -L "$l_fpath" -not -path "$l_fpath/lost+found" -type f \( ! -group root -a ! -group adm \))

        if [ -z "$l_invalid_files" ]; then
            echo -e "\n- Audit Result:\n ** PASS **\n - All audit log files are owned by 'root' or 'adm'."
        else
            echo -e "\n- Audit Result:\n ** FAIL **\n - The following files are not owned by 'root' or 'adm':"
            ls -l $l_invalid_files
        fi
    else
        echo -e "\n- Audit Result:\n ** FAIL **\n - File: \"/etc/audit/auditd.conf\" not found.\n - ** Verify auditd is installed **"
    fi
}

# Run checks
check_log_group
check_audit_log_ownership
