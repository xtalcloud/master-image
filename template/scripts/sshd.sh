#!/bin/sh

# Configure debugging
set -eux
set -o pipefail
command -v bc || dnf install -y bc
command -v tput || dnf install -y ncurses
PS4='$(tput setaf 4)$(printf "%-12s\\t%.3fs\\t@line\\t%-10s" $(date +%T) $(echo $(date "+%s.%3N")-'$(date "+%s.%3N")' | bc ) $LINENO)$(tput sgr
0)'

SSHD_CONFIG="/etc/ssh/sshd_config"

if [ -f $SSHD_CONFIG ]; then
# ensure that there is a trailing newline before attempting to concatenate
sed -i -e '$a\' "$SSHD_CONFIG"

USEDNS="UseDNS no"
if grep -q -E "^[[:space:]]*UseDNS" "$SSHD_CONFIG"; then
    sed -i "s/^\s*UseDNS.*/${USEDNS}/" "$SSHD_CONFIG"
else
    echo "$USEDNS" >>"$SSHD_CONFIG"
fi

PWAUTH="PasswordAuthentication no"
if grep -q -E "^[[:space:]]*PasswordAuthentication" "$SSHD_CONFIG"; then
    sed -i "s/^\s*PasswordAuthentication.*/${PWAUTH}/" "$SSHD_CONFIG"
else
    echo "$PWAUTH" >>"$SSHD_CONFIG"
fi

GSSAPI="GSSAPIAuthentication no"
if grep -q -E "^[[:space:]]*GSSAPIAuthentication" "$SSHD_CONFIG"; then
    sed -i "s/^\s*GSSAPIAuthentication.*/${GSSAPI}/" "$SSHD_CONFIG"
else
    echo "$GSSAPI" >>"$SSHD_CONFIG"
fi
fi
