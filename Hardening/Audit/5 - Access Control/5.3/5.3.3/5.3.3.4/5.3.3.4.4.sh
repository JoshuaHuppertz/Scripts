#!/bin/bash

# Datei zur Überprüfung
PAM_FILE="/etc/pam.d/common-password"

# Überprüfen, ob die Datei existiert
if [[ ! -f "$PAM_FILE" ]]; then
  echo "FAIL: Die Datei $PAM_FILE existiert nicht."
  exit 1
fi

# Befehl zum Überprüfen, ob use_authtok in der pam_unix.so Zeile vorhanden ist
if grep -PH -- '^\h*password\h+([^#\n\r]+)\h+pam_unix\.so\h+([^#\n\r]+\h+)?use_authtok\b' "$PAM_FILE" > /dev/null; then
  echo "PASS: use_authtok ist korrekt gesetzt in $PAM_FILE."
else
  echo "FAIL: use_authtok ist NICHT gesetzt in $PAM_FILE."
fi
