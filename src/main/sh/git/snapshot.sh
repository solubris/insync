#!/usr/bin/env bash

# get the contents of the repo only
# can't be used to push files back or further checkouts

set -eo pipefail

# TODO use this var: GITHUB_SERVER_URL
#GITHUB_SERVER_URL=https://github.com

repo="$1"
token="$2"
branch="$3"

git clone --depth=1 --no-single-branch --no-tags "https://none:$token@github.com/$repo.git" .

if [ -n "$branch" ]; then
  echo "switching to branch $branch"
  git checkout "$branch"
fi

rm -rf .git
