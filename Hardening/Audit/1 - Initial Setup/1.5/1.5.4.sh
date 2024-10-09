#!/usr/bin/env bash

# Überprüfen, ob prelink installiert ist
if dpkg-query -s prelink &>/dev/null; then
    echo -e "\n- Audit Result:\n ** FAIL **\n prelink is installed.\n"
else
    echo -e "\n- Audit Result:\n ** PASS **\n prelink is not installed.\n"
fi
