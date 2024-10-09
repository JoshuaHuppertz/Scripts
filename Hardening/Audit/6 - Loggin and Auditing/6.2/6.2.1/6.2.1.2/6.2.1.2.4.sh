#!/usr/bin/env bash

# Funktion zur Überprüfung des Dienststatus
check_journal_remote_service() {
    local services=("systemd-journal-remote.socket" "systemd-journal-remote.service")

    local enabled_output
    local active_output

    # Überprüfen, ob die Dienste aktiviert sind
    enabled_output=$(systemctl is-enabled "${services[@]}" 2>/dev/null | grep '^enabled')

    # Überprüfen, ob die Dienste aktiv sind
    active_output=$(systemctl is-active "${services[@]}" 2>/dev/null | grep '^active')

    # Ausgabe der Ergebnisse
    if [[ -z $enabled_output ]]; then
        echo "- systemd-journal-remote.socket and systemd-journal-remote.service are NOT enabled."
    else
        echo "- One or both services are enabled!"
    fi

    if [[ -z $active_output ]]; then
        echo "- systemd-journal-remote.socket and systemd-journal-remote.service are NOT active."
    else
        echo "- One or both services are active!"
    fi

    # Pass/Fail Logik
    if [[ -z $enabled_output && -z $active_output ]]; then
        return 0  # PASS
    else
        return 1  # FAIL
    fi
}

# Überprüfung durchführen
check_journal_remote_service

# Ergebnis auswerten und ausgeben
if [[ $? -eq 0 ]]; then
    echo -e "\n- Audit Result:\n ** PASS **\n - systemd-journal-remote.socket and systemd-journal-remote.service are not enabled or active.\n"
else
    echo -e "\n- Audit Result:\n ** FAIL **\n - One or both of systemd-journal-remote.socket or systemd-journal-remote.service are either enabled or active.\n"
fi
