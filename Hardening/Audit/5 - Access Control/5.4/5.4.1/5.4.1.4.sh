#!/bin/bash

# Überprüfen der ENCRYPT_METHOD in /etc/login.defs
LOGIN_DEFS="/etc/login.defs"

# Überprüfen, ob die Datei /etc/login.defs existiert
if [[ ! -f "$LOGIN_DEFS" ]]; then
  echo "FAIL: Die Datei $LOGIN_DEFS existiert nicht."
  exit 1
fi

# Überprüfen der ENCRYPT_METHOD
encrypt_method=$(grep -Pi -- '^\h*ENCRYPT_METHOD\h+(SHA512|yescrypt)\b' "$LOGIN_DEFS" | awk '{print $2}')

if [[ "$encrypt_method" == "SHA512" || "$encrypt_method" == "yescrypt" ]]; then
  echo "PASS: ENCRYPT_METHOD ist auf $encrypt_method gesetzt und entspricht der lokalen Richtlinie."
else
  echo "FAIL: ENCRYPT_METHOD ist nicht korrekt gesetzt: $encrypt_method."
fi
