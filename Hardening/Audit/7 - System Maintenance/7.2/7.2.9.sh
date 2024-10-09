#!/usr/bin/env bash

{
    l_output=""      # Output for correctly configured checks
    l_output2=""     # Output for failure checks
    l_heout2=""      # Home directory existence issues
    l_hoout2=""      # Ownership issues
    l_haout2=""      # Permission issues

    # Get valid shells
    l_valid_shells="^($(awk -F/ '$NF != "nologin" {print}' /etc/shells | sed -rn '/^\//{s,/,\\\\/,g;p}' | paste -s -d '|'))$"

    unset a_uarr && a_uarr=() # Clear and initialize array

    # Populate array with users and their home locations
    while read -r l_epu l_eph; do 
        a_uarr+=("$l_epu $l_eph")
    done <<< "$(awk -v pat="$l_valid_shells" -F: '$(NF) ~ pat { print $1 " " $(NF-1) }' /etc/passwd)"

    l_asize="${#a_uarr[@]}" # Number of users
    [ "$l_asize" -gt 10000 ] && echo -e "\n ** INFO **\n - \"$l_asize\" Local interactive users found on the system\n - This may be a long running check\n"

    # Check each user's home directory
    while read -r l_user l_home; do
        if [ -d "$l_home" ]; then
            l_mask='0027'
            l_max="$(printf '%o' $((0777 & ~$l_mask)))"
            while read -r l_own l_mode; do
                [ "$l_user" != "$l_own" ] && l_hoout2+="\n - User: \"$l_user\" Home \"$l_home\" is owned by: \"$l_own\""
                if [ $((l_mode & l_mask)) -gt 0 ]; then
                    l_haout2+="\n - User: \"$l_user\" Home \"$l_home\" is mode: \"$l_mode\" should be mode: \"$l_max\" or more restrictive"
                fi
            done <<< "$(stat -Lc '%U %#a' "$l_home")"
        else
            l_heout2+="\n - User: \"$l_user\" Home \"$l_home\" Doesn't exist"
        fi
    done <<< "$(printf '%s\n' "${a_uarr[@]}")"

    # Build outputs for correct configurations
    [ -z "$l_heout2" ] && l_output+="\n - Home directories exist" || l_output2+="$l_heout2"
    [ -z "$l_hoout2" ] && l_output+="\n - Users own their home directories" || l_output2+="$l_hoout2"
    [ -z "$l_haout2" ] && l_output+="\n - Home directories are mode: \"$l_max\" or more restrictive" || l_output2+="$l_haout2"

    # Formatting final output
    if [ -n "$l_output" ]; then
        l_output=" - All local interactive users:$l_output"
    fi

    if [ -z "$l_output2" ]; then
        # If no issues found, audit passes
        echo -e "\n- Audit Result:\n ** PASS **\n - * Correctly configured * :$l_output"
    else
        # If issues found, audit fails
        echo -e "\n- Audit Result:\n ** FAIL **\n - * Reasons for audit failure * :$l_output2"
        [ -n "$l_output" ] && echo -e "\n- * Correctly configured * :$l_output"
    fi
}
