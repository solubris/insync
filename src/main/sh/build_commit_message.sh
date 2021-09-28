#!/usr/bin/env bash

set -eo pipefail

event_file="$1"
message_file="$2"

jq -r '.head_commit.message' "$event_file" > "$message_file"
echo >> "$message_file"
echo 'Triggered by change in source repo:' >> "$message_file"
jq -r '.head_commit.url' "$event_file" >> "$message_file"
echo 'Powered by insync:' >> "$message_file"
echo 'https://github.com/marketplace/actions/in-sync-action' >> "$message_file"
