#!/usr/bin/env bash

git update-index --refresh >/dev/null
git diff-index --quiet HEAD --
changed=$?
if [ $changed -eq 0 ]; then
  echo 0
else
  echo 1
fi
