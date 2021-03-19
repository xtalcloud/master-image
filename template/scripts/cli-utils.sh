#!/bin/sh

#
#  Command-line Utilities
#

echo "Installing fd."

FD_RELEASE='v8.2.1'
FD_REPO='https://github.com/sharkdp/fd'
FD_ARCHIVE="fd-$FD_RELEASE-x86_64-unknown-linux-gnu.tar.gz"
(
	cd /tmp
	curl -sSL "$FD_REPO/releases/download/$FD_RELEASE/$FD_ARCHIVE" | tar xz
	cd "fd-$FD_RELEASE-x86_64-unknown-linux-gnu"
	install fd /usr/bin/
	chmod 644 ./autocomplete/_fd
	chown root:root ./autocomplete/_fd
	mv ./autocomplete/_fd /usr/share/zsh/site-functions/
)

echo "Installing rg."

RG_RELEASE='12.1.1'
RG_REPO='https://github.com/BurntSushi/ripgrep'
RG_ARCHIVE="ripgrep-$RG_RELEASE-x86_64-unknown-linux-musl.tar.gz"
(
	cd /tmp
	curl -sSL "$RG_REPO/releases/download/$RG_RELEASE/$RG_ARCHIVE" | tar xz
	cd "ripgrep-$RG_RELEASE-x86_64-unknown-linux-musl"
	install rg /usr/bin/
	chmod 644 ./complete/_rg
	chown root:root ./complete/_rg
	mv ./complete/_rg /usr/share/zsh/site-functions/
)

echo "Installing bat."

BAT_RELEASE='v0.18.0'
BAT_REPO='https://github.com/sharkdp/bat'
BAT_ARCHIVE="bat-$BAT_RELEASE-x86_64-unknown-linux-gnu.tar.gz"
(
	cd /tmp
	curl -sSL "$BAT_REPO/releases/download/$BAT_RELEASE/$BAT_ARCHIVE" | tar xz
	cd "bat-$BAT_RELEASE-x86_64-unknown-linux-gnu"
	install bat /usr/bin/
	chmod 644 ./autocomplete/bat.zsh
	chown root:root ./autocomplete/bat.zsh
	mv ./autocomplete/bat.zsh /usr/share/zsh/site-functions/_bat
)

echo "Installing croc."

CROC_RELEASE='8.6.11'
CROC_REPO='https://github.com/schollz/croc'
CROC_ARCHIVE="croc_${CROC_RELEASE}_Linux-64bit.tar.gz"
(
	cd /tmp
	curl -sSL "$CROC_REPO/releases/download/v$CROC_RELEASE/$CROC_ARCHIVE" | tar xz \
		&& install croc /usr/bin
)
