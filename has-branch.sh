#!/usr/bin/env bash

THE_PATH=$1

pushd "$THE_PATH" >/dev/null

git ls-remote --heads origin "$BRANCH_NAME" | wc -l

popd >/dev/null
