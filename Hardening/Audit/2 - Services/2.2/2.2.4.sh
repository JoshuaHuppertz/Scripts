#!/usr/bin/env bash

# Überprüfe, ob telnet installiert ist
if dpkg-query -s telnet &>/dev/null; then
    echo -e "\n- Audit Result:\n ** FAIL **\n - Reason: \"telnet is installed\"\n"
else
    echo -e "\n- Audit Result:\n ** PASS **\n - Reason: \"telnet is not installed\"\n"
fi
