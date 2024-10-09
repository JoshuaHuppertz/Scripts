#!/usr/bin/env bash

# Überprüfen, ob gdm3 installiert ist
if dpkg-query -s gdm3 &>/dev/null; then
    result="FAIL: gdm3 is installed."
else
    result="PASS: gdm3 is not installed."
fi

# Ausgabe des Ergebnisses
echo -e "\n- Audit Result for gdm3:\n$result\n"
