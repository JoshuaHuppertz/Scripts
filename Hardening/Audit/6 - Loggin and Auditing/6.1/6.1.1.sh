#!/usr/bin/env bash

# Überprüfen der Installation von aide und aide-common
{
  # Überprüfen, ob aide installiert ist
  if dpkg-query -s aide &>/dev/null; then
    aide_status="PASS: aide is installed"
  else
    aide_status="FAIL: aide is not installed"
  fi

  # Überprüfen, ob aide-common installiert ist
  if dpkg-query -s aide-common &>/dev/null; then
    aide_common_status="PASS: aide-common is installed"
  else
    aide_common_status="FAIL: aide-common is not installed"
  fi

  # Ausgabe der Ergebnisse
  echo -e "\n- Audit Result:"
  echo -e "  - $aide_status"
  echo -e "  - $aide_common_status"
}
