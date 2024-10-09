#!/usr/bin/env bash

# Initialisieren der Ausgabewerte
l_output="" 
l_output2="" 
l_output3="" 
l_dl=""  # Unset output variables

# Setzen der Modulparameter
l_mname="tipc"  # Modulname
l_mtype="net"   # Modultyp
l_searchloc="/lib/modprobe.d/*.conf /usr/local/lib/modprobe.d/*.conf /run/modprobe.d/*.conf /etc/modprobe.d/*.conf"
l_mpath="/lib/modules/**/kernel/$l_mtype"
l_mpname="$(tr '-' '_' <<< "$l_mname")"
l_mndir="$(tr '-' '/' <<< "$l_mname")"

module_loadable_chk() {
    # Überprüfen, ob das Modul ladbar ist
    l_loadable="$(modprobe -n -v "$l_mname")"
    [ "$(wc -l <<< "$l_loadable")" -gt "1" ] && l_loadable="$(grep -P -- "(^\h*install|\b$l_mname)\b" <<< "$l_loadable")"
    
    if grep -Pq -- '^\h*install \/bin\/(true|false)' <<< "$l_loadable"; then
        l_output="$l_output\n - Modul: \"$l_mname\" ist nicht ladbar: \"$l_loadable\""
    else
        l_output2="$l_output2\n - Modul: \"$l_mname\" ist ladbar: \"$l_loadable\""
    fi
}

module_loaded_chk() {
    # Überprüfen, ob das Modul geladen ist
    if ! lsmod | grep "$l_mname" > /dev/null 2>&1; then
        l_output="$l_output\n - Modul: \"$l_mname\" ist nicht geladen"
    else
        l_output2="$l_output2\n - Modul: \"$l_mname\" ist geladen"
    fi
}

module_deny_chk() {
    # Überprüfen, ob das Modul in der Denyliste steht
    l_dl="y"
    if modprobe --showconfig | grep -Pq -- '^\h*blacklist\h+'"$l_mpname"'\b'; then
        l_output="$l_output\n - Modul: \"$l_mname\" steht in der Denyliste: \"$(grep -Pls -- "^\h*blacklist\h+$l_mname\b" $l_searchloc)\""
    else
        l_output2="$l_output2\n - Modul: \"$l_mname\" steht nicht in der Denyliste"
    fi
}

# Überprüfen, ob das Modul im System existiert
for l_mdir in $l_mpath; do
    if [ -d "$l_mdir/$l_mndir" ] && [ -n "$(ls -A "$l_mdir/$l_mndir")" ]; then
        l_output3="$l_output3\n - \"$l_mdir\""
        
        [ "$l_dl" != "y" ] && module_deny_chk
        
        if [ "$l_mdir" = "/lib/modules/$(uname -r)/kernel/$l_mtype" ]; then
            module_loadable_chk
            module_loaded_chk
        fi
    else
        l_output="$l_output\n - Modul: \"$l_mname\" existiert nicht in \"$l_mdir\""
    fi
done

# Ergebnisse ausgeben. Wenn keine Fehler in l_output2, dann PASS
[ -n "$l_output3" ] && echo -e "\n\n -- INFO --\n - Modul: \"$l_mname\" existiert in:$l_output3"
if [ -z "$l_output2" ]; then
    echo -e "\n- Audit Ergebnis:\n ** PASS **\n$l_output\n"
else
    echo -e "\n- Audit Ergebnis:\n ** FAIL **\n - Gründe für das Auditversagen:\n$l_output2\n"
    [ -n "$l_output" ] && echo -e "\n- Korrekt gesetzte:\n$l_output\n"
fi
