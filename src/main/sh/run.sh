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

echo "syncing ${files[*]} to $REPOSITORIES"
pwd
set

echo "dry run=$DRY_RUN"

#  "pusher": {
#    "email": "timlwalters@yahoo.co.uk",
#    "name": "lithium147"
#  },
pusher_email=$( jq -r '.pusher.email' "$GITHUB_EVENT_PATH" )
pusher_name=$( jq -r '.pusher.name' "$GITHUB_EVENT_PATH" )
echo "pusher: $pusher_name $pusher_email"
"$SCRIPT_PATH"/build_commit_message.sh "$GITHUB_EVENT_PATH" "$SCRIPT_PATH/description.txt"

#GITHUB_ACTOR=lithium147

# only run on pushes to master (or other specified branch)
# can be controlled by the job setup

#GITHUB_REPOSITORY=solubris/insync-src
#GITHUB_REPOSITORY_OWNER=solubris

src_path="$(mktemp -d /tmp/insync-src.XXXXXX)"
cd "$src_path"
"$SCRIPT_PATH"/git/snapshot.sh "$GITHUB_REPOSITORY" "$SRC_TOKEN"
ls -la

# loop through all the destination repositories
for repository in ${REPOSITORIES[*]}; do
  if [[ ! $repository = */* ]]; then
    echo "no owner found, using $GITHUB_REPOSITORY_OWNER"
    repository="$GITHUB_REPOSITORY_OWNER/$repository"
    echo "new repository: $repository"
  fi
  branch=''
  if [[ $repository = *@* ]]; then
    branch="${repository#*@}"
    repository="${repository%@*}"
    echo "branch found: $branch"
    echo "new repository: $repository"
  fi

  dst_path="$(mktemp -d /tmp/insync-dst.XXXXXX)"
  cd "$dst_path"
  "$SCRIPT_PATH"/git/checkout.sh "$repository" "$DST_TOKEN" "$pusher_email" "$pusher_name" "$branch"
  ls -la

  if [ -n "$PR_BRANCH" ]; then
    # if there is a PR_BRANCH already in the remote, start from that
    # otherwise create it
    git checkout "$PR_BRANCH" || git checkout -b "$PR_BRANCH"
  fi

  "$SCRIPT_PATH"/sync_from.sh "$src_path" ${files[*]}
  git add .

  local_changes=$($SCRIPT_PATH/git/has_local_changes.sh)
  if [ $local_changes -ne 0 ]; then
    echo 'found changes, pushing'
    $SCRIPT_PATH/git/push.sh "$PR_BRANCH" "$PR_BRANCH" $SCRIPT_PATH/description.txt
    $SCRIPT_PATH/hub/create_pr.sh "$PR_BRANCH" $SCRIPT_PATH/description.txt
  else
    echo 'no changes made, will not do anything'
  fi
done