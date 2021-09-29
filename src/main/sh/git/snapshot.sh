#!/usr/bin/env bash

# get the contents of the repo only
# can't be used to push files back or further checkouts

set -eo pipefail

# TODO use this var: GITHUB_SERVER_URL
#GITHUB_SERVER_URL=https://github.com

REPO="$1"
TOKEN="$2"
BRANCH="$3"

git clone --depth=1 --no-single-branch --no-tags "https://none:$TOKEN@github.com/$REPO.git" .

if [ -n "$BRANCH" ]; then
  echo "switching to branch $BRANCH"
  git checkout "$BRANCH"
fi

rm -rf .git
