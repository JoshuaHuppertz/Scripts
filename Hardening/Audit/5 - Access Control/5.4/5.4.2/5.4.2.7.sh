#!/usr/bin/env bash

# Überprüfen von Systemkonten mit gültigem Login-Shell
{
  echo "Überprüfen von Systemkonten auf gültige Login-Shells..."

  # Gültige Shells aus /etc/shells extrahieren
  l_valid_shells="^($(awk -F\/ '$NF != "nologin" {print}' /etc/shells | sed -rn '/^\//{s,/,\\\\/,g;p}' | paste -s -d '|' - ))$"
  
  # Ermitteln der UID_MIN aus /etc/login.defs
  uid_min="$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)"
  
  # Überprüfen der Konten
  invalid_accounts=$(awk -v pat="$l_valid_shells" -v uid_min="$uid_min" -F: '
    ($1!~/^(root|halt|sync|shutdown|nfsnobody)$/ && ($3<uid_min || $3 == 65534) && $(NF) ~ pat) {
      print "Service account: \"" $1 "\" has a valid shell: " $7
    }' /etc/passwd)

  # Überprüfung des Ergebnisses
  if [[ -z "$invalid_accounts" ]]; then
    echo "PASS: Alle Systemkonten haben kein gültiges Login-Shell."
  else
    echo -e "FAIL: Folgende Systemkonten haben ein gültiges Login-Shell:\n$invalid_accounts"
  fi
}
