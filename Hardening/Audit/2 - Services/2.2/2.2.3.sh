#!/usr/bin/env bash

# Überprüfe, ob talk installiert ist
if dpkg-query -s talk &>/dev/null; then
    echo -e "\n- Audit Result:\n ** FAIL **\n - Reason: \"talk is installed\"\n"
else
    echo -e "\n- Audit Result:\n ** PASS **\n - Reason: \"talk is not installed\"\n"
fi
