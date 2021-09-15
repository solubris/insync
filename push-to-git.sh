#!/usr/bin/env bash

branch_name=$1
commit_title="$2"
commit_message_file="$3"

git config user.name "insync"
git config user.email "insync@github.com"
#GITHUB_SERVER_URL=https://github.com
git config --add hub.host $GITHUB_SERVER_URL

git update-index --refresh
git diff-index --quiet HEAD --
changed=$?
if [ $changed -eq 0 ]; then
  echo no changes
  exit
fi

commit_message=$(cat $commit_message_file)

echo "creating branch and pushing to origin"
git checkout -b $branch_name
git add .
git commit -m "$commit_title" -m "$commit_message"
git push -u origin $branch_name

# must be on master
#  currentBranch=$(git rev-parse --abbrev-ref HEAD)
#  if [[ $currentBranch != "master" ]]; then
#    echo "can only create pr from master"
#    return
#  fi

# to delete the remote branch if not happy
# git push -d origin uppercase-hex-digits
