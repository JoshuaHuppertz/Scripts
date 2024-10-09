#!/usr/bin/env bash

{
  l_output=""
  l_override_file="/etc/tmpfiles.d/systemd.conf"
  l_default_file="/usr/lib/tmpfiles.d/systemd.conf"

  # Überprüfen, ob die Override-Datei existiert
  if [ -f "$l_override_file" ]; then
    l_config_file="$l_override_file"
    l_output+="\n- Override file found: $l_config_file\n"
  else
    l_config_file="$l_default_file"
    l_output+="\n- No override file found. Inspecting default file: $l_config_file\n"
  fi

  # Überprüfen der Dateiberechtigungen
  l_permissions=$(stat -c "%a" "$l_config_file")
  if [ "$l_permissions" -le 640 ]; then
    l_output+="\n- Audit Result:\n ** PASS **\n - File permissions are set to mode $l_permissions (correctly restrictive).\n"
  else
    l_output+="\n- Audit Result:\n ** FAIL **\n - File permissions are set to mode $l_permissions (not restrictive enough).\n"
  fi

  # Ausgabe des Ergebnisses
  echo -e "$l_output"
}
