#!/usr/bin/env bash

# Überprüfe, ob ldap-utils installiert ist
if dpkg-query -s ldap-utils &>/dev/null; then
    echo -e "\n- Audit Result:\n ** FAIL **\n - Reason: \"ldap-utils is installed\"\n"
else
    echo -e "\n- Audit Result:\n ** PASS **\n - Reason: \"ldap-utils is not installed\"\n"
fi
