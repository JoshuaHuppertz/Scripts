#!/usr/bin/env bash

{
    l_output=""
    l_output2=""
    
    # Initialize arrays to hold unowned and ungrouped files/directories
    a_nouser=()
    a_nogroup=()
    
    # Define paths to exclude
    a_path=(
        ! -path "/run/user/*"
        ! -path "/proc/*"
        ! -path "*/containerd/*"
        ! -path "*/kubelet/pods/*"
        ! -path "*/kubelet/plugins/*"
        ! -path "/sys/fs/cgroup/memory/*"
        ! -path "/var/*/private/*"
    )

    # Find mounted file systems
    while IFS= read -r l_mount; do
        # Find files and directories with no user or group
        while IFS= read -r -d $'\0' l_file; do
            if [ -e "$l_file" ]; then
                while IFS=: read -r l_user l_group; do
                    [ "$l_user" = "UNKNOWN" ] && a_nouser+=("$l_file")
                    [ "$l_group" = "UNKNOWN" ] && a_nogroup+=("$l_file")
                done < <(stat -Lc '%U:%G' "$l_file")
            fi
        done < <(find "$l_mount" -xdev \( "${a_path[@]}" \) \( -type f -o -type d \) \( -nouser -o -nogroup \) -print0 2> /dev/null)
    done < <(findmnt -Dkerno fstype,target | awk '($1 !~ /^\s*(nfs|proc|smb|vfat|iso9660|efivarfs|selinuxfs)/ && $2 !~ /^\/run\/user\//) { print $2 }')

    # Generate output based on findings
    if (( ${#a_nouser[@]} > 0 )); then
        l_output2+="\n - There are \"${#a_nouser[@]}\" unowned files or directories on the system.\n"
        l_output2+=" - The following is a list of unowned files and/or directories:\n$(printf '%s\n' "${a_nouser[@]}")\n - end of list"
    else
        l_output+="\n - No files or directories without an owner exist on the local filesystem."
    fi

    if (( ${#a_nogroup[@]} > 0 )); then
        l_output2+="\n - There are \"${#a_nogroup[@]}\" ungrouped files or directories on the system.\n"
        l_output2+=" - The following is a list of ungrouped files and/or directories:\n$(printf '%s\n' "${a_nogroup[@]}")\n - end of list"
    else
        l_output+="\n - No files or directories without a group exist on the local filesystem."
    fi

    # Cleanup
    unset a_path
    unset a_arr
    unset a_nouser
    unset a_nogroup

    # Final output
    echo -e "\n- Audit Result:"
    if [ -z "$l_output2" ]; then
        echo -e " ** PASS **\n - * Correctly configured *:\n$l_output\n"
    else
        echo -e " ** FAIL **\n - * Reasons for audit failure *:\n$l_output2"
        [ -n "$l_output" ] && echo -e "\n- * Correctly configured *:\n$l_output\n"
    fi
}
