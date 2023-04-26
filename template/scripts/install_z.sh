#!/usr/bin/env sh -x

#
#  Install: z
#

#set +x
#set -o pipefail

Z_RELEASE='1.11'
Z_REPO='https://github.com/rupa/z'

# Configure debugging
set -eux
set -o pipefail
command -v bc || dnf install -y bc
command -v tput || dnf install -y ncurses
PS4='$(tput setaf 4)$(printf "%-12s\\t%.3fs\\t@line\\t%-10s" $(date +%T) $(echo $(date "+%s.%3N")-'$(date "+%s.%3N")' | bc ) $LINENO)$(tput sgr0)'

Z_REPO_ROOT="https://raw.githubusercontent.com/rupa/z/v$Z_RELEASE"
Z_TARGET_DIR=/usr/share/z
TEST_CMD="test -f $HOME/.z"

printf "Installing command: z (%s)\\n" "$Z_RELEASE"
(
	set -x
	cd /tmp
	mkdir -p $Z_TARGET_DIR
	curl -Lo $Z_TARGET_DIR/z.sh $Z_REPO_ROOT/z.sh
	curl -Lo /usr/share/man/man1/z\.1 $Z_REPO_ROOT/z.1
	echo ". $Z_TARGET_DIR" >> $HOME/.zshrc
)
