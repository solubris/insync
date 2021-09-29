#!/usr/bin/env bash

set -eo pipefail

# TODO use this var: GITHUB_SERVER_URL
#GITHUB_SERVER_URL=https://github.com

REPO="$1"
TOKEN="$2"
EMAIL="$3"
NAME="$4"
BRANCH="$5"

git clone --depth=1 --no-single-branch --no-tags "https://none:$TOKEN@github.com/$REPO.git" .

if [ -n "$BRANCH" ]; then
  # can't be done as part of clone command
  echo switching to branch $BRANCH
  git checkout "$BRANCH"
fi
if [ -n "$EMAIL" ]; then
  git config user.email "$EMAIL"
fi
if [ -n "$NAME" ]; then
  git config user.name "$NAME"
fi

# only required for github enterprise
#git config --add hub.host "github.com"
