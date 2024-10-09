#!/usr/bin/env bash

check_audit_file_group_ownership() {
    echo "Checking group ownership of audit configuration files..."

    # Find files that are not owned by group root
    non_root_group_files=$(find /etc/audit/ -type f \( -name '*.conf' -o -name '*.rules' \) ! -group root)

    if [ -z "$non_root_group_files" ]; then
        echo -e "\n- Audit Result:\n ** PASS **\n - All audit configuration files are owned by group: 'root'."
    else
        echo -e "\n- Audit Result:\n ** FAIL **\n - The following files are not owned by 'root' group:$non_root_group_files"
    fi
}

# Run the check
check_audit_file_group_ownership
