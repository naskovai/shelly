#!/bin/bash

RELEASE_VERSION=$1
CHANGELOG_MESSAGE=$2

# Check if the version and message are provided
if [ -z "$RELEASE_VERSION" ] || [ -z "$CHANGELOG_MESSAGE" ]; then
    echo "Usage: $0 <release-version> <changelog-message>"
    exit 1
fi

# Update the changelog
dch --newversion "$RELEASE_VERSION" "$CHANGELOG_MESSAGE"

# Commit the change
git add changelog
git commit -m "Update debian changelog for release $RELEASE_VERSION
