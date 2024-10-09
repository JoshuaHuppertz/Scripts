#!/usr/bin/env bash

# Funktion zur Überprüfung der Installation
check_systemd_journal_remote() {
    if dpkg-query -s systemd-journal-remote &>/dev/null; then
        echo "systemd-journal-remote is installed"
        return 0  # Erfolgreich
    else
        echo "systemd-journal-remote is not installed"
        return 1  # Fehler
    fi
}

# Überprüfung durchführen
result=$(check_systemd_journal_remote)

# Ergebnis auswerten und ausgeben
if [[ $result == *"is installed"* ]]; then
    echo -e "\n- Audit Result:\n ** PASS **\n - $result\n"
else
    echo -e "\n- Audit Result:\n ** FAIL **\n - $result\n"
fi
