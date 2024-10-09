#!/usr/bin/env bash

{
    # Werte für lock-delay und idle-delay abfragen
    lock_delay=$(gsettings get org.gnome.desktop.screensaver lock-delay | awk '{print $2}')
    idle_delay=$(gsettings get org.gnome.desktop.session idle-delay | awk '{print $2}')
    
    output=""
    output_fail=""
    
    # Überprüfung für lock-delay
    if [ "$lock_delay" -le 5 ]; then
        output="$output\n - Lock delay is set to $lock_delay seconds (PASS)"
    else
        output_fail="$output_fail\n - Lock delay is set to $lock_delay seconds (FAIL): should be 5 seconds or less"
    fi
    
    # Überprüfung für idle-delay
    if [ "$idle_delay" -gt 0 ] && [ "$idle_delay" -le 900 ]; then
        output="$output\n - Idle delay is set to $idle_delay seconds (PASS)"
    else
        output_fail="$output_fail\n - Idle delay is set to $idle_delay seconds (FAIL): should be 900 seconds or less and not 0"
    fi
    
    # Ergebnis ausgeben
    if [ -z "$output_fail" ]; then
        echo -e "\n- Audit Result:\n *** PASS ***\n$output\n"
    else
        echo -e "\n- Audit Result:\n *** FAIL ***\n$output_fail\n"
        [ -n "$output" ] && echo -e "\n- Correctly set:\n$output\n"
    fi
}
