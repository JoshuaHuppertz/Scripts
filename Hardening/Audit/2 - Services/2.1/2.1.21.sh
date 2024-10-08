#!/usr/bin/env bash
{
    l_output=""
    l_output2=""
    a_port_list=("25" "465" "587")

    # Überprüfen, ob inet_interfaces nicht auf all gesetzt ist
    if [ "$(postconf -n inet_interfaces)" != "inet_interfaces = all" ]; then
        for l_port_number in "${a_port_list[@]}"; do
            if ss -plntu | grep -P -- ':'"$l_port_number"'\b' | grep -Pvq -- '\h+(127\.0\.0\.1|\[?::1\]?):'"$l_port_number"'\b'; then
                l_output2="$l_output2\n - Port \"$l_port_number\" is listening on a non-loopback network interface"
            else
                l_output="$l_output\n - Port \"$l_port_number\" is not listening on a non-loopback network interface"
            fi
        done
    else
        l_output2="$l_output2\n - Postfix is bound to all interfaces"
    fi

    # Ausgabe der Ergebnisse
    if [ -z "$l_output2" ]; then
        echo -e "\n- Audit Result:\n ** PASS **\n$l_output\n"
    else
        # Wenn Fehlerausgabe (l_output2) nicht leer ist, dann failen wir. Auch korrekt konfigurierte Ausgaben.
        echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$l_output2\n"
        [ -n "$l_output" ] && echo -e "\n- Correctly set:\n$l_output\n"
    fi
}
