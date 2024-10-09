#!/usr/bin/env bash

{
    l_output=""
    l_output2=""
    a_parlist=("^\h*(server|pool)\h+\H+")
    l_chrony_config_dir="/etc/chrony" # Chrony configuration directory

    config_file_parameter_chk() {
        unset A_out
        declare -A A_out
        while read -r l_out; do
            if [ -n "$l_out" ]; then
                if [[ $l_out =~ ^\s*# ]]; then
                    l_file="${l_out//# /}"
                else
                    l_chrony_parameter="$(awk -F= '{print $1}' <<< "$l_out" | xargs)"
                    A_out+=(["$l_chrony_parameter"]="$l_file")
                fi
            fi
        done < <(find "$l_chrony_config_dir" -name '*.conf' -exec systemd-analyze cat-config {} + | grep -Pio '^\h*([^#\n\r]+|#\h*\/[^#\n\r\h]+\.conf\b)')
        
        if (( ${#A_out[@]} > 0 )); then
            for l_chrony_parameter in "${!A_out[@]}"; do
                l_file="${A_out[$l_chrony_parameter]}"
                l_output="$l_output\n - \"$l_chrony_parameter\" is set in \"$l_file\"\n"
            done
        else
            l_output2="$l_output2\n - No 'server' or 'pool' settings found in Chrony configuration files\n"
        fi
    }

    for l_chrony_parameter_regex in "${a_parlist[@]}"; do
        config_file_parameter_chk
    done

    # Provide output from checks
    if [ -z "$l_output2" ]; then
        echo -e "\n- Audit Result:\n ** PASS **\n$l_output"
    else
        echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$l_output2"
        [ -n "$l_output" ] && echo -e "\n- Correctly set:\n$l_output"
    fi
}
