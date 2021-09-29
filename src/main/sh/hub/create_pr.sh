#!/usr/bin/env bash
# requires env var: GITHUB_TOKEN

title="$1"
message_file="$2"

# bullet formatting for pr description
#message=$(sed 's/^/* /' $message_file)
message=$(sed 's/^//' $message_file)

# each -m means a new line will be added
hub pull-request -m $title -m '' -m "$message" || true
# TODO if pr already exists, perhaps description could be updated

# -l java

# --no-edit - doesn't work as it cant detect commits
# also tried with unpushed changes, still doesn't work
#hub pull-request --no-edit -l java -p
