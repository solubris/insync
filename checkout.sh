#!/usr/bin/env bash

SCRIPT_PATH=$(dirname "$0")
TEMP_PATH="$(mktemp -d /tmp/insync.XXXXXX)"

cd "$TEMP_PATH"
git clone https://github.com/$1/$2.git

cd "$2"

