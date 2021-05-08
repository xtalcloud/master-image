#!/bin/sh -eux

dnf -y update

# Updating the oracle release on at least OL 6 updates the repos and unlocks a whole
# new set of updates that need to be applied. If this script is there it should be run
if [ -f "/usr/bin/ol_yum_configure.sh" ]; then
  /usr/bin/ol_yum_configure.sh
  yum -y update
fi

reboot;
sleep 60;
