#!/bin/sh

#
#  Install: bat
#

BAT_RELEASE='0.23.0'

# Configure debugging
set -eux
set -o pipefail
command -v bc || dnf install -y bc
command -v tput || dnf install -y ncurses
PS4='$(tput setaf 4)$(printf "%-12s\\t%.3fs\\t@line\\t%-10s" $(date +%T) $(echo $(date "+%s.%3N")-'$(date "+%s.%3N")' | bc ) $LINENO)$(tput sgr0)'

BAT_REPO='https://github.com/sharkdp/bat'
if [ $(uname -m) = "aarch64" ]; then
  BAT_ARCHIVE="bat-v$BAT_RELEASE-aarch64-unknown-linux-gnu.tar.gz"
elif [ $(uname -m) = "x86_64" ]; then
  BAT_ARCHIVE="bat-v$BAT_RELEASE-x86_64-unknown-linux-gnu.tar.gz"
else
  echo "Architecture not supported!"
  exit 1
fi
TEST_CMD='bat -V'

printf "Installing command: bat (%s)\n" "$BAT_RELEASE"
(
        cd /tmp
        curl -sSL "$BAT_REPO/releases/download/v$BAT_RELEASE/$BAT_ARCHIVE" | tar xz
        cd "${BAT_ARCHIVE%.tar.gz}"
        install bat /usr/bin/
        chmod 644 ./autocomplete/bat.zsh
        chown root:root ./autocomplete/bat.zsh
        mv ./autocomplete/bat.zsh /usr/share/zsh/site-functions/_bat
)

eval $TEST_CMD | grep -q "$BAT_RELEASE"

echo 'Successfully installed bat!'
