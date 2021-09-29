#!/usr/bin/env bash

branch_name=$1
commit_title="$2"
commit_message_file="$3"

commit_message=$(cat $commit_message_file)

echo "creating branch and pushing to origin"
#git checkout -b $branch_name
#git add .
git commit -m "$commit_title" -m "$commit_message"

if [ "$DRY_RUN" == "true" ]; then
  dry_run_opt="--dry-run"
  echo "dry-run::push will be made with $dry_run_opt option"
fi

git push $dry_run_opt -u origin $branch_name
