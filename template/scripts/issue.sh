#!/bin/sh -eux

MSG_NET='
Authorized uses only. All activity may be monitored and reported.
'

MSG_LOCAL='
Authorized uses only. All activity may be monitored and reported.
'

if [ -d /etc/issue.d ]; then
    ISSUE_CONFIG='/etc/issue.d/99-warning'
    echo "$MSG_LOCAL" > "$ISSUE_CONFIG"
    chmod 0755 "$ISSUE_CONFIG"
else
    echo "$MSG_LOCAL" > /etc/issue
fi

if [ -d /etc/issue.net.d ]; then
    ISSUE_NET_CONFIG='/etc/issue.net.d/99-warning'
    echo "$MSG_NET" > "$ISSUE_NET_CONFIG"
    chmod 0755 "$ISSUE_NET_CONFIG"
else
    echo "$MSG_NET" > /etc/issue.net
fi
