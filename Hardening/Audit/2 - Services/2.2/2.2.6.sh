#!/usr/bin/env bash

# Überprüfe, ob ftp installiert ist
if dpkg-query -s ftp &>/dev/null; then
    echo -e "\n- Audit Result:\n ** FAIL **\n - Reason: \"ftp is installed\"\n"
else
    echo -e "\n- Audit Result:\n ** PASS **\n - Reason: \"ftp is not installed\"\n"
fi
