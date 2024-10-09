#!/usr/bin/env bash

# Variablen initialisieren
l_output=""
l_output2=""
a_parlist=("fs.suid_dumpable=0")
l_ufwscf="$([ -f /etc/default/ufw ] && awk -F= '/^\s*IPT_SYSCTL=/ {print $2}' /etc/default/ufw)"

# Funktion zur Überprüfung der Kernel-Parameter
kernel_parameter_chk() {
    l_krp="$(sysctl "$l_kpname" | awk -F= '{print $2}' | xargs)" # Aktuelle Konfiguration prüfen
    if [ "$l_krp" = "$l_kpvalue" ]; then
        l_output="$l_output\n - \"$l_kpname\" is correctly set to \"$l_krp\" in the running configuration"
    else
        l_output2="$l_output2\n - \"$l_kpname\" is incorrectly set to \"$l_krp\" in the running configuration and should have a value of: \"$l_kpvalue\""
    fi

    # Überprüfen der dauerhaften Einstellungen (Dateien)
    unset A_out
    declare -A A_out
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

    # UFW-Konfiguration berücksichtigen
    if [ -n "$l_ufwscf" ]; then
        l_kpar="$(grep -Po "^\h*$l_kpname\b" "$l_ufwscf" | xargs)"
        l_kpar="${l_kpar//\//.}"
        [ "$l_kpar" = "$l_kpname" ] && A_out+=(["$l_kpar"]="$l_ufwscf")
    fi

    # Ergebnisse aus Dateien auswerten
    if (( ${#A_out[@]} > 0 )); then
        while IFS="=" read -r l_fkpname l_fkpvalue; do
            l_fkpname="${l_fkpname// /}"; l_fkpvalue="${l_fkpvalue// /}"
            if [ "$l_fkpvalue" = "$l_kpvalue" ]; then
                l_output="$l_output\n - \"$l_kpname\" is correctly set to \"$l_fkpvalue\" in \"$(printf '%s' "${A_out[@]}")\""
            else
                l_output2="$l_output2\n - \"$l_kpname\" is incorrectly set to \"$l_fkpvalue\" in \"$(printf '%s' "${A_out[@]}")\" and should have a value of: \"$l_kpvalue\""
            fi
        done < <(grep -Po -- "^\h*$l_kpname\h*=\h*\H+" "${A_out[@]}")
    else
        l_output2="$l_output2\n - \"$l_kpname\" is not set in an included file\n ** Note: \"$l_kpname\" may be set in a file that's ignored by load procedure **"
    fi
}

# Hauptschleife zur Überprüfung der Parameter
while IFS="=" read -r l_kpname l_kpvalue; do
    l_kpname="${l_kpname// /}"; l_kpvalue="${l_kpvalue// /}"
    kernel_parameter_chk
done < <(printf '%s\n' "${a_parlist[@]}")

# Ergebnisse zur Überprüfung der Kernel-Parameter ausgeben
if [ -z "$l_output2" ]; then
    echo -e "\n- Audit Result for Kernel Parameters:\n ** PASS **\n$l_output\n"
else
    echo -e "\n- Audit Result for Kernel Parameters:\n ** FAIL **\n - Reason(s) for audit failure:\n$l_output2\n"
    [ -n "$l_output" ] && echo -e "\n- Correctly set:\n$l_output\n"
fi

# Überprüfen, ob systemd-coredump installiert ist
if systemctl list-unit-files | grep -q 'coredump'; then
    echo -e "\n- Audit Result for systemd-coredump:\n ** PASS **\n"
else
    echo -e "\n- Audit Result for systemd-coredump:\n ** FAIL **\n systemd-coredump is not installed.\n"
fi
