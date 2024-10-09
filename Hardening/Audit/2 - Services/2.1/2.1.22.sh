#!/usr/bin/env bash
{
    l_output=""
    l_output2=""

    # Führe den Befehl aus und speichere die Ausgabe
    l_ss_output=$(ss -plntu)

    # Überprüfe die Dienste in der Ausgabe
    echo "$l_ss_output" | while read -r line; do
        # Ignoriere die Kopfzeile
        if [[ "$line" == *"Netid"* ]]; then
            continue
        fi

        # Hier fügen Sie die Logik ein, um zu überprüfen, ob der Dienst erforderlich und genehmigt ist.
        # Beispiel: Überprüfen auf einen bestimmten Dienst
        service_name=$(echo "$line" | awk '{print $6}' | cut -d'/' -f2)
        
        # Hier kann eine Logik hinzugefügt werden, um zu überprüfen, ob der Dienst genehmigt ist
        if [[ "$service_name" == "unapproved_service_name" ]]; then
            l_output2="$l_output2\n - Service \"$service_name\" is not approved"
        else
            l_output="$l_output\n - Service \"$service_name\" is approved"
        fi
    done

    # Ausgabe der Ergebnisse
    if [ -z "$l_output2" ]; then
        echo -e "\n- Audit Result:\n ** PASS **\n$l_output\n"
    else
        echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$l_output2\n"
        [ -n "$l_output" ] && echo -e "\n- Correctly approved services:\n$l_output\n"
    fi
}
