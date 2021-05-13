#!/bin/sh

#
#  Install: lnav
#

# NOTE:
#- The musl version of the release is included below for security reasons, as
#- it is a fully linked version of the binary while the the glibc binary is
#- self described as 'a "mostly" statically linked' binary, opening the door
#- for shared-object injection attacks.

LNAV_RELEASE='0.9.0'
LNAV_REPO='https://github.com/tstack/lnav'
LNAV_BIN_ARCHIVE="lnav-$LNAV_RELEASE-musl-64bit.zip"
LNAV_SRC_ARCHIVE="lnav-$LNAV_RELEASE.tar.gz"
INSTALL_ADDITIONAL_FORMATS=1
ADD_CONFIG_TO_SKEL=1
TEST_CMD='lnav -V'

set -x 
printf "Installing command: lnav (%s)\n" "$LNAV_RELEASE"

(
	TMP_DIR=$(mktemp -d)
	cd $TMP_DIR

	curl -sSLO "$LNAV_REPO/releases/download/v$LNAV_RELEASE/$LNAV_BIN_ARCHIVE"
	unzip -jod $TMP_DIR $LNAV_BIN_ARCHIVE lnav-$LNAV_RELEASE/lnav
	install $TMP_DIR/lnav /usr/bin/
	mkdir -pm 0700 /root/.config/lnav

	curl -sSL "$LNAV_REPO/releases/download/v$LNAV_RELEASE/$LNAV_SRC_ARCHIVE" \
		| tar -xz --directory $TMP_DIR --strip=1 lnav-$LNAV_RELEASE/lnav.1 
	install $TMP_DIR/lnav.1 /usr/share/man/man1/
)


eval $TEST_CMD | grep -q `echo "${LNAV_RELEASE//./\\\.}"` || {
	printf "Failed to install lnav (%s)\n:" "$LNAV_RELEASE" 
	printf "Command '%s' failed with status %s.\n" "$TEST_CMD" "$?"
	exit 1
}


if [ $INSTALL_ADDITIONAL_FORMATS -eq 1 ]; then
	LNAV_FMTS_COMMIT='ac531c10d2c12c2f144e272af25d3a4768f4c861'
	LNAV_FMTS_REPO='https://github.com/PaulWay/lnav-formats'
	LNAV_FMTS_ARCHIVE="$LNAV_FMTS_COMMIT.zip"

	FMTS_DIR=/root/.config/lnav/formats/installed
	FMTS_TEST_CMD="find $FMTS_DIR/ -type f"

	printf "Installing: PaulWay's lnav formats (%s)\n" "$LNAV_FMTS_COMMIT"

	(
		cd /tmp
		curl -sSLo lnav_fmts.zip "$LNAV_FMTS_REPO/archive/$LNAV_FMTS_ARCHIVE"
		unzip -jod /root/.config/lnav/formats/installed/ lnav_fmts.zip '*.json'
		
		chown root.root $FMTS_DIR/*
		mkdir -pm 0700 $FMTS_DIR
		chmod 0600 $FMTS_DIR/*

		eval $FMTS_TEST_CMD	|| {
			printf "Failed to install lnav extra log formats (%s)\n:" "$LNAV_FMTS_COMMIT" 
			printf "Command '%s' failed with status %s.\n" "$FMTS_TEST_CMD" "$?"
			exit 1
		}

		if [ $ADD_CONFIG_TO_SKEL -eq 1 ]; then
			FMTS_SKEL_DIR=/etc/skel/.config/lnav/formats/installed
			FMTS_SKEL_TEST_CMD="find $FMTS_DIR/ -type f"

			mkdir -pm 0700 $FMTS_SKEL_DIR
			cd $FMTS_DIR
			cp *.json $FMTS_SKEL_DIR
			
			set -x
			eval $FMTS_SKEL_TEST_CMD || {
				printf "\nFailed to copy lnav extra log formats to /etc/skel (%s):\n" "$LNAV_FMTS_COMMIT" 
				printf "Command '%s' failed with status %s.\n\n" "$FMTS_TEST_CMD" "$?"
				exit 1
			}
		fi
	)
fi
