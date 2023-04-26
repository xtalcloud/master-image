#!/bin/sh

#
#  Install: lnav
#

LNAV_RELEASE='0.11.1'

# Configure debugging
set -eux
set -o pipefail
command -v bc || dnf install -y bc
command -v tput || dnf install -y ncurses
PS4='$(tput setaf 4)$(printf "%-12s\\t%.3fs\\t@line\\t%-10s" $(date +%T) $(echo $(date "+%s.%3N")-'$(date "+%s.%3N")' | bc ) $LINENO)$(tput sgr0)'

LNAV_REPO='https://github.com/tstack/lnav'
LNAV_BIN_ARCHIVE="lnav-$LNAV_RELEASE-musl-64bit.zip"
LNAV_SRC_ARCHIVE="lnav-$LNAV_RELEASE.tar.gz"
INSTALL_ADDITIONAL_FORMATS=1
ADD_CONFIG_TO_SKEL=1
TEST_CMD='lnav -V'

printf "Installing command: lnav (%s)\n" "$LNAV_RELEASE"

command -v unzip &>/dev/null || dnf install -y unzip

if [ $(uname -m) = "x86_64" ]; then
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
elif [ $(uname -m) = "aarch64" ]; then
	dnf install -y https://rpm.spencersmolen.com/lnav-0.11.1-1.el9.aarch64.rpm
else
	echo "Architecture not supported!"
	exit 1
fi

eval $TEST_CMD

if [ $INSTALL_ADDITIONAL_FORMATS -eq 1 ]; then
	LNAV_FMTS_COMMIT='ac531c10d2c12c2f144e272af25d3a4768f4c861'
	LNAV_FMTS_REPO='https://github.com/PaulWay/lnav-formats'
	LNAV_FMTS_ARCHIVE="$LNAV_FMTS_COMMIT.zip"

	FMTS_DIR_USER=~/.config/lnav/formats/installed
	FMTS_DIR_SKEL=/etc/skel/.config/lnav/formats/installed

	FMTS_TEST_CMD1="find $FMTS_DIR_USER/ -type f"
	FMTS_TEST_CMD2="find $FMTS_DIR_SKEL/ -type f"

	printf "Installing: PaulWay's lnav formats (%s)\n" "$LNAV_FMTS_COMMIT"

	(
		cd /tmp
		curl -sSLo lnav_fmts.zip "$LNAV_FMTS_REPO/archive/$LNAV_FMTS_ARCHIVE"

		mkdir -pm 0700 $FMTS_DIR_USER
		mkdir -pm 0700 $FMTS_DIR_SKEL

		unzip -jod $FMTS_DIR_USER lnav_fmts.zip '*.json'
		unzip -jod $FMTS_DIR_SKEL lnav_fmts.zip '*.json'
		
		chmod 0600 $FMTS_DIR_USER/*
		chmod 0600 $FMTS_DIR_SKEL/*

		eval $FMTS_TEST_CMD1
		eval $FMTS_TEST_CMD2
	)
fi

echo 'Succesfully installed lnav!'
