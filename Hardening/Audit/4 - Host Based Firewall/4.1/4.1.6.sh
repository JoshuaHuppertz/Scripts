#!/usr/bin/env bash
{
    unset a_ufwout
    unset a_openports

    # UFW-regel Ports abrufen
    while read -r l_ufwport; do
        [ -n "$l_ufwport" ] && a_ufwout+=("$l_ufwport")
    done < <(ufw status verbose | grep -Po '^\h*\d+\b' | sort -u)

    # Offene Ports abrufen
    while read -r l_openport; do
        [ -n "$l_openport" ] && a_openports+=("$l_openport")
    done < <(ss -tuln | awk '($5!~/%lo:/ && $5!~/127.0.0.1:/ && $5!~/\[?::1\]?:/) {split($5, a, ":"); print a[2]}' | sort -u)

    # Unterschiede zwischen offenen Ports und UFW-regel Ports finden
    a_diff=($(comm -13 <(printf '%s\n' "${a_ufwout[@]}" | sort) <(printf '%s\n' "${a_openports[@]}" | sort)))

    # Ergebnisse ausgeben
    if [[ ${#a_diff[@]} -ne 0 ]]; then
        echo -e "\n- Audit Result:\n ** FAIL **\n- The following port(s) don't have a rule in UFW:\n$(printf '%s\n' "${a_diff[@]}")\n- End List"
    else
        echo -e "\n- Audit Result:\n ** PASS **\n- All open ports have a rule in UFW\n"
    fi
}
