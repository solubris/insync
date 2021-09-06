#!/usr/bin/env bash

SCRIPT_PATH=$(dirname "$0")


#dstOwner="$1"
dstRepository="$1"
dstToken="$2"
files=("$3")

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

for f in ${files[*]}; do
  echo checking "$f"
done

# for each file
#   check if it is the push
#   what if the action missed to run on a push?
#   if file has changed
#   copy file into tmp dir
# end

# if there are changes in tmp dir
# push changes to a branch
# create pr

