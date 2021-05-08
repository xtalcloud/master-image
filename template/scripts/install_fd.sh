#!/bin/sh

#
#  Install: fd
#

FD_RELEASE='8.2.1'
FD_REPO='https://github.com/sharkdp/fd'
FD_ARCHIVE="fd-v$FD_RELEASE-x86_64-unknown-linux-gnu.tar.gz"
TEST_CMD='fd -V'

printf "Installing command: fd (%s)\n" "$FD_RELEASE"

(
	cd /tmp
	curl -sSL "$FD_REPO/releases/download/v$FD_RELEASE/$FD_ARCHIVE" | tar xz
	cd "fd-v$FD_RELEASE-x86_64-unknown-linux-gnu"
	install fd /usr/bin/
	chmod 644 ./autocomplete/_fd
	chown root.root ./autocomplete/_fd
	mv ./autocomplete/_fd /usr/share/zsh/site-functions/
)

eval $TEST_CMD | grep -q "$FD_RELEASE" || {
	printf "Failed to install fd (%s)\n:" "$FD_RELEASE" 
	printf "Command '%s' failed with status %s.\n" "$TEST_CMD" "$?"
}
