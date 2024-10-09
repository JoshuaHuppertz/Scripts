#!/usr/bin/env bash

# Überprüfen der TMOUT-Konfiguration
{
  output1=""
  output2=""
  
  # Festlegen der Bash-Konfigurationsdatei
  [ -f /etc/bashrc ] && BRC="/etc/bashrc"

  # Überprüfen der Dateien auf korrekte TMOUT-Konfiguration
  for f in "$BRC" /etc/profile /etc/profile.d/*.sh; do
    if grep -Pq '^\s*([^#]+\s+)?TMOUT=(900|[1-8][0-9][0-9]|[1-9][0-9]|[1-9])\b' "$f" &&
       grep -Pq '^\s*([^#]+;\s*)?readonly\s+TMOUT(\s+|\s*;|\s*$|=(900|[1-8][0-9][0-9]|[1-9][0-9]|[1-9]))\b' "$f" &&
       grep -Pq '^\s*([^#]+;\s*)?export\s+TMOUT(\s+|\s*;|\s*$|=(900|[1-8][0-9][0-9]|[1-9][0-9]|[1-9]))\b' "$f"; then
      output1="$f"
    fi
  done

  # Überprüfen auf inkorrekte TMOUT-Konfiguration
  if grep -Pq '^\s*([^#]+\s+)?TMOUT=(9[0-9][1-9]|9[1-9][0-9]|0+|[1-9]\d{3,})\b' /etc/profile /etc/profile.d/*.sh "$BRC"; then
    output2=$(grep -Ps '^\s*([^#]+\s+)?TMOUT=(9[0-9][1-9]|9[1-9][0-9]|0+|[1-9]\d{3,})\b' /etc/profile /etc/profile.d/*.sh "$BRC")
  fi

  # Ergebnisüberprüfung und Ausgabe
  if [ -n "$output1" ] && [ -z "$output2" ]; then
    echo -e "\nPASSED\n\nTMOUT is configured in: \"$output1\"\n"
  else
    [ -z "$output1" ] && echo -e "\nFAILED\n\nTMOUT is not configured\n"
    [ -n "$output2" ] && echo -e "\nFAILED\n\nTMOUT is incorrectly configured in: \"$output2\"\n"
  fi
}
