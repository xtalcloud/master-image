#!/bin/sh

#
#  Install: ripgrep (rg)
#

RG_RELEASE='12.1.1'
RG_REPO='https://github.com/BurntSushi/ripgrep'
RG_ARCHIVE="ripgrep-$RG_RELEASE-x86_64-unknown-linux-musl.tar.gz"
TEST_CMD='rg -V'

printf "Installing command: rg (%s)\n" "$RG_RELEASE"

(
	cd /tmp
	curl -sSL "$RG_REPO/releases/download/$RG_RELEASE/$RG_ARCHIVE" | tar xz
	cd "ripgrep-$RG_RELEASE-x86_64-unknown-linux-musl"
	install rg /usr/bin/
	chmod 644 ./complete/_rg
	chown root.root ./complete/_rg
	mv ./complete/_rg /usr/share/zsh/site-functions/
)

set +x
eval $TEST_CMD | grep -q "$RG_RELEASE" || {
	printf "\nFailed to install rg (%s):\n" "$RG_RELEASE" 
	printf "Command '%s' failed with status %s.\n\n" "$TEST_CMD" "$?"
	exit 1
}
