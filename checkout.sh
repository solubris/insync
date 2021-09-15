#!/usr/bin/env bash

#git config user.name github-actions
#git config user.email github-actions@github.com
# TODO use this var: GITHUB_SERVER_URL

# use hub to clone so its setup for creating the pr later on
hub clone "https://$2:x-oauth-basic@github.com/$1.git" .
