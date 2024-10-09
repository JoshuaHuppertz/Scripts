#!/usr/bin/env bash

# Überprüfe, ob nis installiert ist
if dpkg-query -s nis &>/dev/null; then
    echo -e "\n- Audit Result:\n ** FAIL **\n - Reason: \"nis is installed\"\n"
else
    echo -e "\n- Audit Result:\n ** PASS **\n - Reason: \"nis is not installed\"\n"
fi
