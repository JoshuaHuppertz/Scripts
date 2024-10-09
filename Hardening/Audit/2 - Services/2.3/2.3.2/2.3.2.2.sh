#!/usr/bin/env bash

{
    l_output=""
    l_output2=""

    # Check if systemd-timesyncd is enabled
    if systemctl is-enabled systemd-timesyncd.service &>/dev/null; then
        if systemctl is-enabled systemd-timesyncd.service | grep -q 'enabled'; then
            l_output+=" - systemd-timesyncd service is enabled.\n"
        else
            l_output2+=" - systemd-timesyncd service is not enabled.\n"
        fi
    else
        l_output2+=" - systemd-timesyncd service is not installed or not recognized.\n"
    fi

    # Check if systemd-timesyncd is active
    if systemctl is-active systemd-timesyncd.service &>/dev/null; then
        if systemctl is-active systemd-timesyncd.service | grep -q 'active'; then
            l_output+=" - systemd-timesyncd service is active.\n"
        else
            l_output2+=" - systemd-timesyncd service is not active.\n"
        fi
    else
        l_output2+=" - systemd-timesyncd service is not installed or not recognized.\n"
    fi

    # Provide output from checks
    if [ -z "$l_output2" ]; then
        echo -e "\n- Audit Result:\n ** PASS **\n$l_output"
    else
        echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$l_output2"
        [ -n "$l_output" ] && echo -e "\n- Correctly set:\n$l_output"
    fi
}
