#!/usr/bin/env bash

THE_PATH=$1

pushd "$THE_PATH" >/dev/null

git update-index --refresh >/dev/null
git diff-index --quiet HEAD --
changed=$?
if [ $changed -eq 0 ]; then
  echo 0
else
  echo 1
fi

popd >/dev/null
