#!/usr/bin/env bash

{
    # Überprüfen, ob xserver-common installiert ist
    if dpkg-query -s xserver-common &> /dev/null; then
        echo -e "\n- Audit Result:\n ** FAIL **\n - Reason: xserver-common is installed."
    else
        echo -e "\n- Audit Result:\n ** PASS **\n - xserver-common is not installed."
    fi
}
