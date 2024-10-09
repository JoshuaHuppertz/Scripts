#!/usr/bin/env bash

# Initialisieren der Ausgabewerte
l_output=""
l_output2=""

# Funktion zur Überprüfung von Modulen
module_chk() {
    # Überprüfen, wie das Modul geladen wird
    l_loadable="$(modprobe -n -v "$l_mname")"
    if grep -Pq -- '^\h*install \/bin\/(true|false)' <<< "$l_loadable"; then
        l_output="$l_output\n - Modul: \"$l_mname\" ist nicht ladbar:\n \"$l_loadable\""
    else
        l_output2="$l_output2\n - Modul: \"$l_mname\" ist ladbar:\n \"$l_loadable\""
    fi

    # Überprüfen, ob das Modul derzeit geladen ist
    if ! lsmod | grep "$l_mname" > /dev/null 2>&1; then
        l_output="$l_output\n - Modul: \"$l_mname\" ist nicht geladen"
    else
        l_output2="$l_output2\n - Modul: \"$l_mname\" ist geladen"
    fi

    # Überprüfen, ob das Modul in der Denyliste steht
    if modprobe --showconfig | grep -Pq -- "^\h*blacklist\h+$l_mname\b"; then
        l_output="$l_output\n - Modul: \"$l_mname\" steht in der Denyliste:\n \"$(grep -Pl -- "^\h*blacklist\h+$l_mname\b" /etc/modprobe.d/*)\""
    else
        l_output2="$l_output2\n - Modul: \"$l_mname\" steht nicht in der Denyliste"
    fi
}

# Überprüfen, ob drahtlose NICs installiert sind
if [ -n "$(find /sys/class/net/*/ -type d -name wireless)" ]; then
    l_dname=$(for driverdir in $(find /sys/class/net/*/ -type d -name wireless | xargs -0 dirname); do
        basename "$(readlink -f "$driverdir"/device/driver/module)"
    done | sort -u)

    for l_mname in $l_dname; do
        module_chk
    done
fi

# Ergebnisse ausgeben
if [ -z "$l_output2" ]; then
    echo -e "\n- Audit Ergebnis:\n ** PASS **"
    if [ -z "$l_output" ]; then
        echo -e "\n - Es sind keine drahtlosen NICs im System installiert."
    else
        echo -e "\n$l_output\n"
    fi
else
    echo -e "\n- Audit Ergebnis:\n ** FAIL **\n - Gründe für das Auditversagen:\n$l_output2\n"
    [ -n "$l_output" ] && echo -e "\n- Korrekt gesetzte:\n$l_output\n"
fi
