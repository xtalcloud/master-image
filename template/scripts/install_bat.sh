#!/bin/sh

#
#  Install: bat
#

# NOTE:
#- The musl version of the release is included below for security reasons, as
#- it is a fully linked version of the binary while the the glibc binary is
#- self described as 'a "mostly" statically linked' binary, opening the door
#- for shared-object injection attacks.

BAT_RELEASE='0.18.0'
BAT_REPO='https://github.com/sharkdp/bat'
BAT_ARCHIVE="bat-v$BAT_RELEASE-x86_64-unknown-linux-musl.tar.gz"
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

set +x
eval $TEST_CMD | grep -q "$BAT_RELEASE" || {
	printf "\nFailed to install bat (%s):\n" "$BAT_RELEASE" 
	printf "Command '%s' failed with status %s.\n\n" "$TEST_CMD" "$?"
	exit 1
}
