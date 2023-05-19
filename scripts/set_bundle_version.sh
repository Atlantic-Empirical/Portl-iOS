#!/bin/sh

function quit {
    echo
    echo $1
    echo
    exit 1
}

NEW_VERSION=${1:-0}

PLIST_FILE="$PWD/portkey/Supporting Files/Info.plist"

MARKETING_VERSION=$(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" "${PLIST_FILE}")

if [ $? -ne 0 ]
then
    quit "PlistBuddy failed: $MARKETING_VERSION"
fi

# Write new version into the plist.
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $NEW_VERSION" "${PLIST_FILE}"
