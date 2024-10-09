#!/usr/bin/env bash

# Überprüfen des umask-Werts für den root-Benutzer
echo "Überprüfen des umask-Werts für den root-Benutzer..."

# Überprüfen der .bash_profile und .bashrc auf umask
umask_check=$(grep -Psi -- '^\h*umask\h+(([0-7][0-7][01][0-7]\b|[0-7][0-7][0-7][0-6]\b)|([0-7][01][0-7]\b|[0-7][0-7][0-6]\b)|(u=[rwx]{1,3},)?(((g=[rx]?[rx]?w[rx]?[rx]?\b)(,o=[rwx]{1,3})?)|((g=[wrx]{1,3},)?o=[wrx]{1,3}\b)))' /root/.bash_profile /root/.bashrc)

# Überprüfung des Ergebnisses
if [[ -z "$umask_check" ]]; then
  echo "PASS: Der umask-Wert ist korrekt konfiguriert (kein unerwünschter umask-Wert gefunden)."
else
  echo -e "FAIL: Folgende umask-Werte wurden gefunden:\n$umask_check"
fi
