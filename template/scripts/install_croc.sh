#!/bin/sh

#
#  Install: croc
#
echo "Installing croc."

CROC_RELEASE='9.1.1'
CROC_REPO='https://github.com/schollz/croc'
CROC_ARCHIVE="croc_${CROC_RELEASE}_Linux-64bit.tar.gz"
TEST_CMD='croc --version'

printf "Installing command: croc (%s)\n" "$CROC_RELEASE"

(
	cd /tmp
	curl -sSL "$CROC_REPO/releases/download/v$CROC_RELEASE/$CROC_ARCHIVE" | tar xz \
		&& install croc /usr/bin
)

eval $TEST_CMD | grep -q "$CROC_RELEASE" || {
	printf "Failed to install bat (%s)\n:" "$CROC_RELEASE" 
	printf "Command '%s' failed with status %s.\n" "$TEST_CMD" "$?"
	exit 1
}
