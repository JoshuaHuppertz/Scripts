#!/usr/bin/env bash

# Überprüfen des Inhalts von /etc/issue
issue_content=$(cat /etc/issue)
expected_content="Dein erwarteter Inhalt hier"  # Ersetze dies mit dem gewünschten Inhalt

# Überprüfen auf Übereinstimmung
if [[ "$issue_content" == *"$expected_content"* ]]; then
    issue_check="PASS: /etc/issue matches site policy."
else
    issue_check="FAIL: /etc/issue does not match site policy."
fi

# Überprüfen auf unerwünschte Zeichen
os_id=$(grep '^ID=' /etc/os-release | cut -d= -f2 | sed -e 's/"//g')
if grep -E -i "(\\\v|\\\r|\\\m|\\\s|$os_id)" /etc/issue &>/dev/null; then
    unwanted_check="FAIL: /etc/issue contains unwanted characters."
else
    unwanted_check="PASS: /etc/issue does not contain unwanted characters."
fi

# Ausgabe der Ergebnisse
echo -e "\n- Audit Result for /etc/issue:\n$issue_check\n$unwanted_check\n"
