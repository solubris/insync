#!/usr/bin/env bash

SCRIPT_PATH=$(dirname "$0")


dstOwner="$1"
dstRepository="$2"
files="$3"

echo "syncing $files to $dstOwner/$dstRepository"
pwd
set

# not much useful in here
#cat $GITHUB_EVENT_PATH

# only run on pushes to master (or other specified branch)
# can be controlled by the job setup

# check out dst project to tmp dir
"$SCRIPT_PATH"/checkout.sh $dstOwner $dstRepository




# for each file
#   check if it is the push
#   what if the action missed to run on a push?
#   if file has changed
#   copy file into tmp dir
# end

# if there are changes in tmp dir
# push changes to a branch
# create pr

