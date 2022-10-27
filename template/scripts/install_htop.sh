#!/bin/sh

#
#  Install: htop
#  Note: requires a registered copy of RHEL to install dependencies
#

set -eux
set -o pipefail

printf "Installing command: htop\n"

(
	cd /tmp
	RPM_FILE='htop-3.0.5-1.el8.aarch64.rpm'
	curl -LO https://dl.fedoraproject.org/pub/epel/8/Everything/aarch64/Packages/h/$RPM_FILE
	rpm -i $RPM_FILE
)
