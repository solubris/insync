#!/usr/bin/env bash

SCRIPT_PATH=$(dirname "$0")

#git config user.name github-actions
#git config user.email github-actions@github.com
# TODO use this var: GITHUB_SERVER_URL

git clone "https://$2:x-oauth-basic@github.com/$1.git"

#cd "$2"

