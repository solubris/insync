#!/usr/bin/env bash

set -eo pipefail

SCRIPT_PATH=$(dirname "$0")

#dstOwner="$1"
dstRepository=$1
shift
files=($*)

dryRun=$DRY_RUN
dstToken=$GITHUB_TOKEN
dstBranch=$DST_BRANCH
prBranch=${PR_BRANCH:-insync}

echo "syncing ${files[*]} to $dstRepository"
pwd
#set

echo "dryRun=$dryRun"

# not much useful in here
pusherEmail=$( cat $GITHUB_EVENT_PATH | jq -r '.pusher.email' )
pusherName=$( cat $GITHUB_EVENT_PATH | jq -r '.pusher.name' )
cat $GITHUB_EVENT_PATH | jq -r '.head_commit.message' > $SCRIPT_PATH/description.txt
echo >> $SCRIPT_PATH/description.txt
echo 'Triggered by change in source repo:' >> $SCRIPT_PATH/description.txt
cat $GITHUB_EVENT_PATH | jq -r '.head_commit.url' >> $SCRIPT_PATH/description.txt
echo 'Powered by insync:' >> $SCRIPT_PATH/description.txt
echo 'https://github.com/marketplace/actions/in-sync-action' >> $SCRIPT_PATH/description.txt

echo "pusher: $pusherName $pusherEmail"

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
"$SCRIPT_PATH"/git-checkout.sh "$dstRepository" "$dstToken" "$pusherEmail" "$pusherName" "$dstBranch" &

# src and dst checkouts can happen in parallel
wait
ls -la "$SRC_PATH"
ls -la "$DST_PATH"

# loop through each dst from here
cd "$DST_PATH"

# if there is a prBranch, start from that, otherwise it will be created later
git checkout "$prBranch" || true

"$SCRIPT_PATH"/sync-from.sh "$SRC_PATH" ${files[*]}

localChanges=$($SCRIPT_PATH/has-local-changes.sh)
if [ $localChanges -ne 0 ]; then
  echo 'found changes, pushing'
  $SCRIPT_PATH/push-to-git.sh "$prBranch" "$prBranch" $SCRIPT_PATH/description.txt
  $SCRIPT_PATH/hub-create-pr.sh "$prBranch" $SCRIPT_PATH/description.txt
else
  echo 'no changes made, will not do anything'
fi
