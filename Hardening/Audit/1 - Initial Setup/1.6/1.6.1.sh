#!/usr/bin/env bash

# Überprüfen des Inhalts von /etc/motd
motd_content=$(cat /etc/motd)
expected_content="Dein erwarteter Inhalt hier"  # Ersetze dies mit dem gewünschten Inhalt

# Überprüfen auf Übereinstimmung
if [[ "$motd_content" == *"$expected_content"* ]]; then
    motd_check="PASS: /etc/motd matches site policy."
else
    motd_check="FAIL: /etc/motd does not match site policy."
fi

# Überprüfen auf unerwünschte Zeichen
os_id=$(grep '^ID=' /etc/os-release | cut -d= -f2 | sed -e 's/"//g')
if grep -E -i "(\\\v|\\\r|\\\m|\\\s|$os_id)" /etc/motd &>/dev/null; then
    unwanted_check="FAIL: /etc/motd contains unwanted characters."
else
    unwanted_check="PASS: /etc/motd does not contain unwanted characters."
fi

# Ausgabe der Ergebnisse
echo -e "\n- Audit Result for /etc/motd:\n$motd_check\n$unwanted_check\n"
