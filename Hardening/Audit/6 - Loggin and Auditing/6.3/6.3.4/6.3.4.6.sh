#!/usr/bin/env bash

check_audit_file_ownership() {
    echo "Checking ownership of audit configuration files..."

    # Find files that are not owned by root
    non_root_files=$(find /etc/audit/ -type f \( -name '*.conf' -o -name '*.rules' \) ! -user root)

    if [ -z "$non_root_files" ]; then
        echo -e "\n- Audit Result:\n ** PASS **\n - All audit configuration files are owned by user: 'root'."
    else
        echo -e "\n- Audit Result:\n ** FAIL **\n - The following files are not owned by 'root':$non_root_files"
    fi
}

# Run the check
check_audit_file_ownership
