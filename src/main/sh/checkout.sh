#!/usr/bin/env bash

set -eo pipefail

# TODO use this var: GITHUB_SERVER_URL
#GITHUB_SERVER_URL=https://github.com

REPO="$1"
TOKEN="$2"
EMAIL="$3"
NAME="$4"
BRANCH="$5"

# TODO token is not required for source repo, so token could be empty

git clone "https://$TOKEN:x-oauth-basic@github.com/$REPO.git" .

if [ "$NAME" != "" ]; then
  git config user.name "$NAME"
fi
if [ "$EMAIL" != "" ]; then
  git config user.email "$EMAIL"
fi

git config --add hub.host "github.com"

if [ "$BRANCH" != "" ]; then
  echo switching to branch $BRANCH
  git checkout "$BRANCH"
fi