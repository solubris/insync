#!/usr/bin/env bash

SCRIPT_PATH=$(dirname "$0")
TEMP_PATH="$(mktemp -d /tmp/insync.XXXXXX)"

cd "$TEMP_PATH"

git config user.name github-actions
git config user.email github-actions@github.com
git clone https://$3:x-oauth-basic@github.com/$1/$2.git

cd "$2"

