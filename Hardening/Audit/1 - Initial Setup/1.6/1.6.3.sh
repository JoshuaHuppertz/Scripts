#!/usr/bin/env bash

# Überprüfen des Inhalts von /etc/issue.net
issue_net_content=$(cat /etc/issue.net)
expected_content="Dein erwarteter Inhalt hier"  # Ersetze dies mit dem gewünschten Inhalt

# Überprüfen auf Übereinstimmung
if [[ "$issue_net_content" == *"$expected_content"* ]]; then
    issue_net_check="PASS: /etc/issue.net matches site policy."
else
    issue_net_check="FAIL: /etc/issue.net does not match site policy."
fi

# Überprüfen auf unerwünschte Zeichen
os_id=$(grep '^ID=' /etc/os-release | cut -d= -f2 | sed -e 's/"//g')
if grep -E -i "(\\\v|\\\r|\\\m|\\\s|$os_id)" /etc/issue.net &>/dev/null; then
    unwanted_check="FAIL: /etc/issue.net contains unwanted characters."
else
    unwanted_check="PASS: /etc/issue.net does not contain unwanted characters."
fi

# Ausgabe der Ergebnisse
echo -e "\n- Audit Result for /etc/issue.net:\n$issue_net_check\n$unwanted_check\n"
