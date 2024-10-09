#!/usr/bin/env bash

# Überprüfen auf einen Cron-Job für aide oder auf aidecheck.service und aidecheck.timer
{
  # Variablen zur Speicherung der Ergebnisse
  cron_job_found=false
  service_enabled=false
  timer_enabled=false
  timer_running=false

  # Überprüfen auf einen Cron-Job für aide
  if grep -Prs '^([^#\n\r]+\h+)?(\/usr\/s?bin\/|^\h*)aide(\.wrapper)?\h+(--(check|update)|([^#\n\r]+\h+)?\$AIDEARGS)\b' /etc/cron.* /etc/crontab /var/spool/cron/; then
    cron_job_found=true
  fi

  # Überprüfen der Dienst- und Timer-Status
  if systemctl is-enabled aidecheck.service &>/dev/null; then
    service_enabled=true
  fi

  if systemctl is-enabled aidecheck.timer &>/dev/null; then
    timer_enabled=true
  fi

  if systemctl status aidecheck.timer | grep -q 'active (running)'; then
    timer_running=true
  fi

  # Ergebnisse ausgeben
  echo -e "\n- Audit Result:"

  if $cron_job_found; then
    echo "  - PASS: Cron job for aide is scheduled."
  elif $service_enabled && $timer_enabled && $timer_running; then
    echo "  - PASS: aidecheck.service and aidecheck.timer are enabled and timer is running."
  else
    echo "  - FAIL: No valid aide cron job found and aidecheck.service or aidecheck.timer is not properly configured."
  fi
}
