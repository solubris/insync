#!/usr/bin/env bash

set -eo pipefail

# TODO use this var: GITHUB_SERVER_URL
#GITHUB_SERVER_URL=https://github.com

repo="$1"
token="$2"
email="$3"
name="$4"
branch="$5"

if [ -z $token ]; then
  echo no token
  git clone --depth=1 --no-single-branch --no-tags "https://github.com/$repo.git" .
else
  git clone --depth=1 --no-single-branch --no-tags "https://none:$token@github.com/$repo.git" .
fi

if [ -n "$branch" ]; then
  # can't be done as part of clone command
  echo switching to branch $branch
  git checkout "$branch"
fi
if [ -n "$email" ]; then
  git config user.email "$email"
fi
if [ -n "$name" ]; then
  git config user.name "$name"
fi

# only required for github enterprise
#git config --add hub.host "github.com"
