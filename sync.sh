#!/usr/bin/env bash

SCRIPT_PATH=$(dirname "$0")


dstRepository="$1"
files="$2"

echo "syncing $files to $dstRepository"
pwd
set

# not much useful in here
#cat $GITHUB_EVENT_PATH

# only run on pushes to master (or other specified branch)
# can be controlled by the job setup

# check out dst project to tmp dir
"$SCRIPT_PATH"/checkout.sh 'solubris' $dstRepository




# for each file
#   check if it is the push
#   what if the action missed to run on a push?
#   if file has changed
#   copy file into tmp dir
# end

# if there are changes in tmp dir
# push changes to a branch
# create pr

