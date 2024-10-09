#!/usr/bin/env bash

{
    l_output=""
    l_output2=""
    a_parlist=(
        "net.ipv4.conf.all.rp_filter=1"
        "net.ipv4.conf.default.rp_filter=1"
    )
    
    l_ufwscf="$([ -f /etc/default/ufw ] && awk -F= '/^\s*IPT_SYSCTL=/ {print $2}' /etc/default/ufw)"
    
    kernel_parameter_chk() {
        l_krp="$(sysctl "$l_kpname" | awk -F= '{print $2}' | xargs)" # Überprüfung der laufenden Konfiguration
        if [ "$l_krp" = "$l_kpvalue" ]; then
            l_output="$l_output\n - \"$l_kpname\" ist korrekt auf \"$l_krp\" in der laufenden Konfiguration gesetzt"
        else
            l_output2="$l_output2\n - \"$l_kpname\" ist inkorrekt auf \"$l_krp\" in der laufenden Konfiguration gesetzt und sollte den Wert haben: \"$l_kpvalue\""
        fi
        
        unset A_out
        declare -A A_out # Überprüfung der dauerhaften Einstellungen (Dateien)
        
        while read -r l_out; do
            if [ -n "$l_out" ]; then
                if [[ $l_out =~ ^\s*# ]]; then
                    l_file="${l_out//# /}"
                else
                    l_kpar="$(awk -F= '{print $1}' <<< "$l_out" | xargs)"
                    [ "$l_kpar" = "$l_kpname" ] && A_out+=(["$l_kpar"]="$l_file")
                fi
            fi
        done < <(/usr/lib/systemd/systemd-sysctl --cat-config | grep -Po '^\h*([^#\n\r]+|#\h*\/[^#\n\r\h]+\.conf\b)')
        
        if [ -n "$l_ufwscf" ]; then # Berücksichtigung von UFW-Systemen
            l_kpar="$(grep -Po "^\h*$l_kpname\b" "$l_ufwscf" | xargs)"
            l_kpar="${l_kpar//\//.}"
            [ "$l_kpar" = "$l_kpname" ] && A_out+=(["$l_kpar"]="$l_ufwscf")
        fi
        
        if (( ${#A_out[@]} > 0 )); then # Ausgaben von Dateien bewerten und generieren
            while IFS="=" read -r l_fkpname l_fkpvalue; do
                l_fkpname="${l_fkpname// /}"; l_fkpvalue="${l_fkpvalue// /}"
                if [ "$l_fkpvalue" = "$l_kpvalue" ]; then
                    l_output="$l_output\n - \"$l_kpname\" ist korrekt auf \"$l_fkpvalue\" in \"$(printf '%s' "${A_out[@]}")\"\n"
                else
                    l_output2="$l_output2\n - \"$l_kpname\" ist inkorrekt auf \"$l_fkpvalue\" in \"$(printf '%s' "${A_out[@]}")\" und sollte den Wert haben: \"$l_kpvalue\"\n"
                fi
            done < <(grep -Po -- "^\h*$l_kpname\h*=\h*\H+" "${A_out[@]}")
        else
            l_output2="$l_output2\n - \"$l_kpname\" ist in einer eingebundenen Datei nicht gesetzt\n ** Hinweis: \"$l_kpname\" könnte in einer Datei gesetzt sein, die vom Ladeverfahren ignoriert wird **\n"
        fi
    }
    
    while IFS="=" read -r l_kpname l_kpvalue; do # Parameter überprüfen
        l_kpname="${l_kpname// /}"; l_kpvalue="${l_kpvalue// /}"
        
        if ! grep -Pqs '^\h*0\b' /sys/module/ipv6/parameters/disable && grep -q '^net.ipv6.' <<< "$l_kpname"; then
            l_output="$l_output\n - IPv6 ist auf dem System deaktiviert, \"$l_kpname\" ist nicht anwendbar"
        else
            kernel_parameter_chk
        fi
    done < <(printf '%s\n' "${a_parlist[@]}")
    
    # Ergebnisse ausgeben: Wenn keine Fehler in l_output2, dann PASS
    if [ -z "$l_output2" ]; then
        echo -e "\n- Audit Ergebnis:\n ** PASS **\n$l_output\n"
    else
        echo -e "\n- Audit Ergebnis:\n ** FAIL **\n - Gründe für das Auditversagen:\n$l_output2\n"
        [ -n "$l_output" ] && echo -e "\n- Korrekt gesetzte:\n$l_output\n"
    fi
}
