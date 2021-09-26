#!/usr/bin/env bash

# TODO use this var: GITHUB_SERVER_URL
#GITHUB_SERVER_URL=https://github.com

REPO=$1
TOKEN=$2

# TODO token is not required for source repo, so token could be empty

git clone "https://$TOKEN:x-oauth-basic@github.com/$REPO.git" .

git config user.name "insync"
git config user.email "insync@github.com"
git config --add hub.host "github.com"
