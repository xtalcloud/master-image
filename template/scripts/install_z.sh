#!/bin/sh

#
#  Install: z
#

set -eux
set -o pipefail

Z_RELEASE='1.11'
Z_REPO='https://github.com/rupa/z'

Z_REPO_ROOT="https://raw.githubusercontent.com/rupa/z/v$Z_RELEASE"
Z_TARGET_DIR=/usr/share/z
TEST_CMD="test -f $HOME/.z"

printf "Installing command: z (%s)\n" "$Z_RELEASE"

(
	cd /tmp
	mkdir -p $Z_TARGET_DIR
	curl -Lo $Z_TARGET_DIR/z.sh $Z_REPO_ROOT/z.sh
	curl -Lo /usr/share/man/man1/z\.1 $Z_REPO_ROOT/z.1
	echo ". $Z_TARGET_DIR" >> $HOME/.zshrc
)
