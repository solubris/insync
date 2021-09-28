#!/usr/bin/env bash

set -eo pipefail
SCRIPT_PATH=$(dirname "$0")

# env vars
# provided by github actions
# - GITHUB_EVENT_PATH: string
#
# provided by action.yaml
# - DRY_RUN: true|false
# - DST_TOKEN: string
# - SRC_TOKEN: string
# - REPOSITORIES: string
# - GITHUB_TOKEN: string
# - PR_BRANCH: string

files=($*)

echo "syncing ${files[*]} to $repository"
pwd
#set

echo "dry run=$DRY_RUN"

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
"$SCRIPT_PATH"/git-snapshot.sh "$GITHUB_REPOSITORY" "$SRC_TOKEN"
ls -la

# loop through all the destination repositories
for repository in ${REPOSITORIES[*]}; do
  owner="$GITHUB_REPOSITORY_OWNER"  # TODO extract from $repository
  branch="" # TODO extract from $repository

  DST_PATH="$(mktemp -d /tmp/insync-dst.XXXXXX)"
  cd "$DST_PATH"
  "$SCRIPT_PATH"/git-checkout.sh "$owner/$repository" "$DST_TOKEN" "$pusher_email" "$pusher_name" "$branch"
  ls -la

  if [ -n "$PR_BRANCH" ]; then
    # if there is a PR_BRANCH already in the remote, start from that
    # otherwise create it
    git checkout "$PR_BRANCH" || git checkout -b "$PR_BRANCH"
  fi

  "$SCRIPT_PATH"/sync-from.sh "$SRC_PATH" ${files[*]}

  localChanges=$($SCRIPT_PATH/has-local-changes.sh)
  if [ $localChanges -ne 0 ]; then
    echo 'found changes, pushing'
    $SCRIPT_PATH/push-to-git.sh "$PR_BRANCH" "$PR_BRANCH" $SCRIPT_PATH/description.txt
    $SCRIPT_PATH/hub-create-pr.sh "$PR_BRANCH" $SCRIPT_PATH/description.txt
  else
    echo 'no changes made, will not do anything'
  fi
done