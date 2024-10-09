#!/usr/bin/env bash
{
    # Standardrichtlinien abrufen
    default_policy=$(ufw status verbose | grep "Default:")

    # Prüfen, ob die Standardrichtlinien die erwarteten Werte haben
    if echo "$default_policy" | grep -q "deny (incoming)" && \
       echo "$default_policy" | grep -q "deny (outgoing)" && \
       echo "$default_policy" | grep -q "disabled (routed)"; then
        echo -e "\n- Audit Result:\n ** PASS **\n- Default policies are correctly set:\n$default_policy\n"
    else
        echo -e "\n- Audit Result:\n ** FAIL **\n- The default policies for UFW are not set correctly:\n$default_policy\n"
    fi
}
