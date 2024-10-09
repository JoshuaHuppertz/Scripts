#!/usr/bin/env bash

{
  l_output=""
  l_fail_output=""
  
  # Funktion zum Überprüfen der Logrotationseinstellungen
  check_log_rotation() {
    local l_file="$1"
    local l_param="$2"
    local l_value

    l_value=$(grep -E "^\s*$l_param\s*=" "$l_file" | awk -F '=' '{print $2}' | xargs)

    if [ -z "$l_value" ]; then
      l_fail_output+="\n - Parameter \"$l_param\" is not configured in \"$l_file\"."
    else
      l_output+="\n - In \"$l_file\", $l_param is set to \"$l_value\"."
      # Hier kannst du die spezifischen Anforderungen für die Werte hinzufügen
    fi
  }

  # Überprüfen der Hauptkonfigurationsdatei
  l_main_file="/etc/systemd/journald.conf"
  if [ -f "$l_main_file" ]; then
    l_output+="\nChecking main configuration file: $l_main_file\n"
    for param in SystemMaxUse SystemKeepFree RuntimeMaxUse RuntimeKeepFree MaxFileSec; do
      check_log_rotation "$l_main_file" "$param"
    done
  else
    l_fail_output+="\n - Main configuration file \"$l_main_file\" not found."
  fi

  # Überprüfen der Konfigurationsdateien im Verzeichnis
  l_conf_dir="/etc/systemd/journald.conf.d/"
  if [ -d "$l_conf_dir" ]; then
    for l_conf_file in "$l_conf_dir"*.conf; do
      if [ -f "$l_conf_file" ]; then
        l_output+="\nChecking configuration file: $l_conf_file\n"
        for param in SystemMaxUse SystemKeepFree RuntimeMaxUse RuntimeKeepFree MaxFileSec; do
          check_log_rotation "$l_conf_file" "$param"
        done
      fi
    done
  fi

  # Ausgabe des Ergebnisses
  if [ -z "$l_fail_output" ]; then
    echo -e "\n- Audit Result:\n ** PASS **\n - Log rotation parameters are correctly configured:$l_output"
  else
    echo -e "\n- Audit Result:\n ** FAIL **\n - * Reasons for audit failure * :$l_fail_output$l_output"
  fi
}
