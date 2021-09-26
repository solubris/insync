#!/usr/bin/env bash

SCRIPT_PATH=$(dirname "$0")
# the branch name to push changes to
BRANCH_NAME='insync'

#dstOwner="$1"
dstRepository=$1
shift
dstToken=$1
shift
files=($*)

echo "syncing ${files[*]} to $dstRepository"
pwd
#set

# not much useful in here
#cat $GITHUB_EVENT_PATH

# only run on pushes to master (or other specified branch)
# can be controlled by the job setup

#GITHUB_REPOSITORY=solubris/insync-src
#GITHUB_REPOSITORY_OWNER=solubris

SRC_PATH="$(mktemp -d /tmp/insync-src.XXXXXX)"
cd "$SRC_PATH"
"$SCRIPT_PATH"/checkout.sh "$GITHUB_REPOSITORY" "$dstToken"
cd -

# check out dst project to tmp dir
DST_PATH="$(mktemp -d /tmp/insync-dst.XXXXXX)"
cd "$DST_PATH"
"$SCRIPT_PATH"/checkout.sh "$dstRepository" "$dstToken"
cd -

ls -la "$SRC_PATH"
ls -la "$DST_PATH"

"$SCRIPT_PATH"/sync.sh "$SRC_PATH" "$DST_PATH" ${files[*]}

# don't push changes if there is already a branch for this change
matchingBranches=$(cd "$DST_PATH"; $SCRIPT_PATH/has-branch.sh "$BRANCH_NAME")
if [ $matchingBranches -ne 0 ]; then
  echo 'branch already exists, will not do anything'
  exit
fi

localChanges=$(cd "$DST_PATH"; $SCRIPT_PATH/has-local-changes.sh)
if [ $localChanges -ne 0 ]; then
  echo 'found changes, pushing'
  cd "$DST_PATH"; $SCRIPT_PATH/push-to-git.sh $BRANCH_NAME "$BRANCH_NAME" $SCRIPT_PATH/description.txt
  cd "$DST_PATH"; $SCRIPT_PATH/hub-create-pr.sh "$BRANCH_NAME" $SCRIPT_PATH/description.txt
else
  echo 'no changes made, will not do anything'
fi



# for each file
#   check if it is the push
#   what if the action missed to run on a push?
#   if file has changed
#   copy file into tmp dir
# end

# if there are changes in tmp dir
# push changes to a branch
# create pr

