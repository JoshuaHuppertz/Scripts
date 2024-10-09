#!/usr/bin/env bash

{
    l_output=""
    l_output2=""
    l_smask='01000'
    
    # Initialize arrays
    a_file=()
    a_dir=()
    
    # Define paths to exclude
    a_path=(
        ! -path "/run/user/*"
        ! -path "/proc/*"
        ! -path "*/containerd/*"
        ! -path "*/kubelet/pods/*"
        ! -path "*/kubelet/plugins/*"
        ! -path "/sys/*"
        ! -path "/snap/*"
    )

    # Find mounted file systems
    while IFS= read -r l_mount; do
        # Find world-writable files and directories
        while IFS= read -r -d $'\0' l_file; do
            if [ -e "$l_file" ]; then
                [ -f "$l_file" ] && a_file+=("$l_file")  # Add world-writable files
                if [ -d "$l_file" ]; then  # Add directories without sticky bit
                    l_mode="$(stat -Lc '%#a' "$l_file")"
                    [ ! $(( $l_mode & $l_smask )) -gt 0 ] && a_dir+=("$l_file")
                fi
            fi
        done < <(find "$l_mount" -xdev \( "${a_path[@]}" \) \( -type f -o -type d \) -perm -0002 -print0 2> /dev/null)
    done < <(findmnt -Dkerno fstype,target | awk '($1 !~ /^\s*(nfs|proc|smb|vfat|iso9660|efivarfs|selinuxfs)/ && $2 !~ /^(\/run\/user\/|\/tmp|\/var\/tmp)/) { print $2 }')

    # Generate output based on findings
    if (( ${#a_file[@]} > 0 )); then
        l_output2+="\n - There are \"${#a_file[@]}\" world-writable files on the system.\n"
        l_output2+=" - The following is a list of world-writable files:\n$(printf '%s\n' "${a_file[@]}")\n - end of list\n"
    else
        l_output+="\n - No world-writable files exist on the local filesystem."
    fi

    if (( ${#a_dir[@]} > 0 )); then
        l_output2+="\n - There are \"${#a_dir[@]}\" world-writable directories without the sticky bit on the system.\n"
        l_output2+=" - The following is a list of world-writable directories without the sticky bit:\n$(printf '%s\n' "${a_dir[@]}")\n - end of list\n"
    else
        l_output+="\n - Sticky bit is set on all world-writable directories on the local filesystem."
    fi

    # Cleanup
    unset a_path
    unset a_arr
    unset a_file
    unset a_dir

    # Final output
    echo -e "\n- Audit Result:"
    if [ -z "$l_output2" ]; then
        echo -e " ** PASS **\n - * Correctly configured *:\n$l_output\n"
    else
        echo -e " ** FAIL **\n - * Reasons for audit failure *:\n$l_output2"
        [ -n "$l_output" ] && echo -e "- * Correctly configured *:\n$l_output\n"
    fi
}
