#!/usr/bin/env bash

# Funktion zur Überprüfung des Dienststatus
check_journal_upload_service() {
    local service_name="systemd-journal-upload.service"

    # Überprüfen, ob der Dienst aktiviert ist
    local is_enabled
    is_enabled=$(systemctl is-enabled "$service_name" 2>/dev/null)

    # Überprüfen, ob der Dienst aktiv ist
    local is_active
    is_active=$(systemctl is-active "$service_name" 2>/dev/null)

    # Ausgabe der Ergebnisse
    if [[ $is_enabled == "enabled" ]]; then
        echo "- $service_name is enabled."
    else
        echo "- $service_name is NOT enabled."
    fi

    if [[ $is_active == "active" ]]; then
        echo "- $service_name is active."
    else
        echo "- $service_name is NOT active."
    fi

    # Pass/Fail Logik
    if [[ $is_enabled == "enabled" && $is_active == "active" ]]; then
        return 0  # PASS
    else
        return 1  # FAIL
    fi
}

# Überprüfung durchführen
check_journal_upload_service

# Ergebnis auswerten und ausgeben
if [[ $? -eq 0 ]]; then
    echo -e "\n- Audit Result:\n ** PASS **\n - systemd-journal-upload is enabled and active.\n"
else
    echo -e "\n- Audit Result:\n ** FAIL **\n - systemd-journal-upload is not properly configured.\n"
fi
