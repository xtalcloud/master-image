#!/bin/sh -eux

RELEASE_FILE=/etc/os-release

VARIANT_NAME=`printf VARIANT="%s" "$IMAGE_NAME"`
if grep -q -E "^[[:space:]]*VARIANT=" $RELEASE_FILE; then
    sed -i "s/^\s*VARIANT=.*/${VARIANT_NAME}/" $RELEASE_FILE
else
    echo "$VARIANT_NAME" >> "$RELEASE_FILE"
fi

BUILD_ID=`printf BUILD_ID="%s" "$BUILD_ID"`
if grep -q -E "^[[:space:]]*BUILD_ID=" $RELEASE_FILE; then
    sed -i "s/^\s*VARIANT=.*/${BUILD_ID}/" $RELEASE_FILE
else
    echo "$BUILD_ID" >> "$RELEASE_FILE"
fi

DOCUMENTATION_URL=`printf DOCUMENTATION_URL="%s" "$DOCUMENTATION_URL"`
if grep -q -E "^[[:space:]]*DOCUMENTATION_URL=" $RELEASE_FILE; then
    sed -i "s/^\s*VARIANT=.*/${DOCUMENTATION_URL}/" $RELEASE_FILE
else
    echo "$DOCUMENTATION_URL" >> "$RELEASE_FILE"
fi
