#!/usr/bin/env bash

# Überprüfen, ob Nicht-Root-Konten ohne gültigen Login-Shell gesperrt sind
{
  echo "Überprüfen von Nicht-Root-Konten auf gültige Login-Shells und Sperrstatus..."

  # Gültige Shells aus /etc/shells extrahieren
  l_valid_shells="^($(awk -F\/ '$NF != "nologin" {print}' /etc/shells | sed -rn '/^\//{s,/,\\\\/,g;p}' | paste -s -d '|' - ))$"

  # Überprüfen der Konten
  locked_accounts=""
  while IFS= read -r l_user; do
    account_status=$(passwd -S "$l_user" | awk '$2 !~ /^L/ {print "Account: \"" $1 "\" does not have a valid login shell and is not locked"}')
    if [[ -n "$account_status" ]]; then
      locked_accounts+="$account_status\n"
    fi
  done < <(awk -v pat="$l_valid_shells" -F: '($1 != "root" && $(NF) !~ pat) {print $1}' /etc/passwd)

  # Überprüfung des Ergebnisses
  if [[ -z "$locked_accounts" ]]; then
    echo "PASS: Alle Nicht-Root-Konten ohne gültigen Login-Shell sind gesperrt."
  else
    echo -e "FAIL: Folgende Nicht-Root-Konten sind nicht gesperrt und haben keinen gültigen Login-Shell:\n$locked_accounts"
  fi
}
