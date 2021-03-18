#!/bin/sh -eux

VARIANT_NAME=`printf 'VARIANT="%s"' "$IMAGE_NAME"`
RELEASE_FILE=/etc/os-release
if grep -q -E "^[[:space:]]*VARIANT=" $RELEASE_FILE; then
    sed -i "s/^\s*VARIANT=.*/${VARIANT_NAME}/" $RELEASE_FILE
else
    echo "$VARIANT_NAME" >> "$RELEASE_FILE"
fi
