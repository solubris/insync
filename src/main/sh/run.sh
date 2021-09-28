#!/usr/bin/env bash

set -eo pipefail
SCRIPT_PATH=$(dirname "$0")

# env vars
# provided by github
# GITHUB_EVENT_PATH: string
#
# provided by action.yaml
# DRY_RUN: true|false

owner="$1"; shift
repository="$1"; shift
files=($*)

dstToken=$GITHUB_TOKEN
dstBranch=$DST_BRANCH
prBranch=${PR_BRANCH:-insync}

echo "syncing ${files[*]} to $repository"
pwd
#set

echo "dry run=$DRY_RUN"

# not much useful in here
pusher_email=$( jq -r '.pusher.email' "$GITHUB_EVENT_PATH" )
pusher_name=$( jq -r '.pusher.name' "$GITHUB_EVENT_PATH" )
jq -r '.head_commit.message' "$GITHUB_EVENT_PATH" > $SCRIPT_PATH/description.txt
echo >> $SCRIPT_PATH/description.txt
echo 'Triggered by change in source repo:' >> $SCRIPT_PATH/description.txt
jq -r '.head_commit.url' "$GITHUB_EVENT_PATH" >> $SCRIPT_PATH/description.txt
echo 'Powered by insync:' >> $SCRIPT_PATH/description.txt
echo 'https://github.com/marketplace/actions/in-sync-action' >> $SCRIPT_PATH/description.txt

echo "pusher: $pusher_name $pusher_email"

#  "pusher": {
#    "email": "timlwalters@yahoo.co.uk",
#    "name": "lithium147"
#  },
#GITHUB_ACTOR=lithium147

# only run on pushes to master (or other specified branch)
# can be controlled by the job setup

#GITHUB_REPOSITORY=solubris/insync-src
#GITHUB_REPOSITORY_OWNER=solubris

SRC_PATH="$(mktemp -d /tmp/insync-src.XXXXXX)"
cd "$SRC_PATH"
"$SCRIPT_PATH"/git-snapshot.sh "$GITHUB_REPOSITORY" "$dstToken" &

# check out dst project to tmp dir
DST_PATH="$(mktemp -d /tmp/insync-dst.XXXXXX)"
cd "$DST_PATH"
"$SCRIPT_PATH"/git-checkout.sh "$owner/$repository" "$dstToken" "$pusher_email" "$pusher_name" "$dstBranch" &

# src and dst checkouts can happen in parallel
wait
ls -la "$SRC_PATH"
ls -la "$DST_PATH"

# loop through each dst from here
cd "$DST_PATH"

# if there is a prBranch, start from that, otherwise create it
git checkout "$prBranch" || git checkout -b "$prBranch"

"$SCRIPT_PATH"/sync-from.sh "$SRC_PATH" ${files[*]}

localChanges=$($SCRIPT_PATH/has-local-changes.sh)
if [ $localChanges -ne 0 ]; then
  echo 'found changes, pushing'
  $SCRIPT_PATH/push-to-git.sh "$prBranch" "$prBranch" $SCRIPT_PATH/description.txt
  $SCRIPT_PATH/hub-create-pr.sh "$prBranch" $SCRIPT_PATH/description.txt
else
  echo 'no changes made, will not do anything'
fi
