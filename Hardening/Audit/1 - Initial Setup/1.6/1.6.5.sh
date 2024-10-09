#!/usr/bin/env bash

# Überprüfen, ob /etc/issue existiert
if [ -e /etc/issue ]; then
    # Überprüfen der Dateiberechtigungen, UID und GID
    stat_output=$(stat -Lc 'Access: (%#a/%A) Uid: ( %u/ %U) Gid: ( %g/ %G)' /etc/issue)

    # Prüfen auf Zugriffsrechte, UID und GID
    access=$(echo "$stat_output" | awk '{print $2}')
    uid=$(echo "$stat_output" | awk '{print $5}')
    gid=$(echo "$stat_output" | awk '{print $8}')

    if [[ "$access" -ge 644 && "$uid" -eq 0 && "$gid" -eq 0 ]]; then
        result="PASS: /etc/issue has correct permissions (Access: $access, Uid: $uid, Gid: $gid)."
    else
        result="FAIL: /etc/issue does not meet the required permissions or ownership (Access: $access, Uid: $uid, Gid: $gid)."
    fi
else
    result="FAIL: /etc/issue does not exist."
fi

# Ausgabe des Ergebnisses
echo -e "\n- Audit Result for /etc/issue:\n$result\n"
