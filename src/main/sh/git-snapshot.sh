#!/usr/bin/env bash

# get the contents of the repo only
# can't be used to push files back or further checkouts

set -eo pipefail

# TODO use this var: GITHUB_SERVER_URL
#GITHUB_SERVER_URL=https://github.com

REPO="$1"
TOKEN="$2"
BRANCH="$3"

# TODO token is not required for source repo, so token could be empty

if [ "$TOKEN" != "" ]; then
  git clone --depth=1 --no-tags "https://$TOKEN:x-oauth-basic@github.com/$REPO.git" .
else
  echo cloning without token
  git clone --depth=1 --no-tags "https://github.com/$REPO.git" .
fi

if [ "$BRANCH" != "" ]; then
  echo switching to branch $BRANCH
  # TODO can be part of the clone command
  git checkout "$BRANCH"
fi

rm -rf .git
