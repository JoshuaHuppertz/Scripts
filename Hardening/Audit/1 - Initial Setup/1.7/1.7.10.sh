#!/usr/bin/env bash

{
    l_output=""
    l_output2=""
    
    # Durchsuche die GDM-Konfigurationsdateien nach der [xdmcp]-Sektion
    while IFS= read -r l_file; do
        result=$(awk '/\[xdmcp\]/{ f = 1;next } /\[/{ f = 0 } f {if (/^\s*Enable\s*=\s*true/) print "The file: \"'"$l_file"'\" includes: \"" $0 "\" in the \"[xdmcp]\" block"}' "$l_file")

        if [[ -n "$result" ]]; then
            l_output="$l_output$result\n"
        fi
    done < <(grep -Psil -- '^\h*\[xdmcp\]' /etc/{gdm3,gdm}/{custom,daemon}.conf)

    # Berichte über die Ergebnisse
    if [[ -n "$l_output" ]]; then
        echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$l_output"
    else
        echo -e "\n- Audit Result:\n ** PASS **\n - No issues found in the [xdmcp] configuration."
    fi
}
