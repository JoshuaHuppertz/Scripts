#!/usr/bin/env bash

# Überprüfe, ob rsh-client installiert ist
if dpkg-query -s rsh-client &>/dev/null; then
    echo -e "\n- Audit Result:\n ** FAIL **\n - Reason: \"rsh-client is installed\"\n"
else
    echo -e "\n- Audit Result:\n ** PASS **\n - Reason: \"rsh-client is not installed\"\n"
fi
