#!/usr/bin/env bash

# Konfigurationsdatei
config_file="/etc/systemd/journal-upload.conf"

# Funktion zur Überprüfung der Authentifizierungskonfiguration
check_journal_upload_auth() {
    if [[ ! -f $config_file ]]; then
        echo "Configuration file not found: $config_file"
        return 1
    fi

    # Extrahiere relevante Zeilen aus der Konfigurationsdatei
    local output
    output=$(grep -P "^ *URL=|^ *ServerKeyFile=|^ *ServerCertificateFile=|^ *TrustedCertificateFile=" "$config_file")

    if [[ -z $output ]]; then
        echo "No authentication configuration found in $config_file"
        return 1
    fi

    echo "$output"
    return 0
}

# Überprüfung durchführen
result=$(check_journal_upload_auth)

# Ergebnis auswerten und ausgeben
if [[ $? -eq 0 ]]; then
    echo -e "\n- Audit Result:\n ** PASS **\n - Authentication configuration found:\n$result\n"
else
    echo -e "\n- Audit Result:\n ** FAIL **\n - $result\n"
fi
