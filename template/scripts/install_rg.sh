#!/bin/sh

#
#  Install: ripgrep (rg)
#

# Configure debugging
set -eux
set -o pipefail
command -v bc || dnf install -y bc
command -v tput || dnf install -y ncurses
PS4='$(tput setaf 4)$(printf "%-12s\\t%.3fs\\t@line\\t%-10s" $(date +%T) $(echo $(date "+%s.%3N")-'$(date "+%s.%3N")' | bc ) $LINENO)$(tput sgr0)'

printf "Installing command: rg\n"

if [ $(uname -m) = "aarch64" ]; then
dnf install -y https://dl.fedoraproject.org/pub/epel/9/Everything/aarch64/Packages/r/ripgrep-13.0.0-6.el9.aarch64.rpm
elif [ $(uname -m) = "x86_64" ]; then
dnf install -y https://dl.fedoraproject.org/pub/epel/9/Everything/x86_64/Packages/r/ripgrep-13.0.0-6.el9.x86_64.rpm
else
echo "Architecture not supported!"
exit 1
fi
