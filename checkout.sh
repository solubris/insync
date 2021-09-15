#!/usr/bin/env bash

#git config user.name github-actions
#git config user.email github-actions@github.com
# TODO use this var: GITHUB_SERVER_URL

git clone "https://$2:x-oauth-basic@github.com/$1.git" .

git config user.name "insync"
git config user.email "insync@github.com"
#GITHUB_SERVER_URL=https://github.com
git config --add hub.host "github.com"
