#!/bin/sh

#
#  Install: fd
#

FD_RELEASE='8.7.0'

# Configure debugging
set -eux
set -o pipefail
command -v bc || dnf install -y bc
command -v tput || dnf install -y ncurses
PS4='$(tput setaf 4)$(printf "%-12s\\t%.3fs\\t@line\\t%-10s" $(date +%T) $(echo $(date "+%s.%3N")-'$(date "+%s.%3N")' | bc ) $LINENO)$(tput sgr0)'

FD_REPO='https://github.com/sharkdp/fd'
if [ $(uname -m) = "aarch64" ]; then
  FD_ARCHIVE="fd-v$FD_RELEASE-aarch64-unknown-linux-gnu.tar.gz"
elif [ $(uname -m) = "x86_64" ]; then
  FD_ARCHIVE="fd-v$FD_RELEASE-x86_64-unknown-linux-gnu.tar.gz"
else
  echo "Architecture not supported!"
  exit 1
fi
TEST_CMD='fd -V'

printf "Installing command: fd (%s)\n" "$FD_RELEASE"

(
        cd /tmp
        curl -sSL "$FD_REPO/releases/download/v$FD_RELEASE/$FD_ARCHIVE" | tar xz
        cd fd-v$FD_RELEASE-*
        install fd /usr/bin/
        chmod 644 ./autocomplete/_fd
        chown root.root ./autocomplete/_fd
        mv ./autocomplete/_fd /usr/share/zsh/site-functions/
)

eval $TEST_CMD | grep -q "$FD_RELEASE"

echo 'Successfully installed fd!'
