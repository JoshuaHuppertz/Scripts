#!/usr/bin/env bash

{
  l_output=""

  # Überprüfung, ob systemd-journald aktiviert ist
  l_enabled_status=$(systemctl is-enabled systemd-journald.service 2>/dev/null)
  if [ "$l_enabled_status" == "static" ]; then
    l_output+="\n- Audit Result:\n ** PASS **\n - systemd-journald is enabled (status: static)"
  else
    l_output+="\n- Audit Result:\n ** FAIL **\n - systemd-journald is not enabled (status: $l_enabled_status)"
  fi

  # Überprüfung, ob systemd-journald aktiv ist
  l_active_status=$(systemctl is-active systemd-journald.service 2>/dev/null)
  if [ "$l_active_status" == "active" ]; then
    l_output+="\n- systemd-journald is active (status: active)"
  else
    l_output+="\n- ** FAIL **\n - systemd-journald is not active (status: $l_active_status)"
  fi

  # Ergebnis ausgeben
  echo -e "$l_output"
}
