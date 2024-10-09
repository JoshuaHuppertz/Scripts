#!/bin/bash

# Check /etc/at.allow
if [ -e "/etc/at.allow" ]; then
    # Get the file details
    ALLOW_STATUS=$(stat -Lc 'Access: (%a) Owner: (%U) Group: (%G)' /etc/at.allow)
    
    # Extract permission, owner, and group
    ALLOW_PERM=$(echo $ALLOW_STATUS | awk '{print $2}' | tr -d '()')
    ALLOW_OWNER=$(echo $ALLOW_STATUS | awk '{print $4}')
    ALLOW_GROUP=$(echo $ALLOW_STATUS | awk '{print $6}')
    
    # Check if permission is 640 or more restrictive, owner is root, and group is daemon or root
    if [ "$ALLOW_PERM" -le 640 ] && [ "$ALLOW_OWNER" = "root" ] && { [ "$ALLOW_GROUP" = "daemon" ] || [ "$ALLOW_GROUP" = "root" ]; }; then
        echo "/etc/at.allow: Pass"
    else
        echo "/etc/at.allow: Fail"
    fi
else
    echo "/etc/at.allow: Fail (File not found)"
fi

# Check /etc/at.deny
if [ -e "/etc/at.deny" ]; then
    # Get the file details
    DENY_STATUS=$(stat -Lc 'Access: (%a) Owner: (%U) Group: (%G)' /etc/at.deny)
    
    # Extract permission, owner, and group
    DENY_PERM=$(echo $DENY_STATUS | awk '{print $2}' | tr -d '()')
    DENY_OWNER=$(echo $DENY_STATUS | awk '{print $4}')
    DENY_GROUP=$(echo $DENY_STATUS | awk '{print $6}')
    
    # Check if permission is 640 or more restrictive, owner is root, and group is daemon or root
    if [ "$DENY_PERM" -le 640 ] && [ "$DENY_OWNER" = "root" ] && { [ "$DENY_GROUP" = "daemon" ] || [ "$DENY_GROUP" = "root" ]; }; then
        echo "/etc/at.deny: Pass"
    else
        echo "/etc/at.deny: Fail"
    fi
else
    echo "/etc/at.deny: Pass (File not found)"
fi
