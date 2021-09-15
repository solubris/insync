#!/usr/bin/env bash

BRANCH_NAME=$1

git ls-remote --heads origin "$BRANCH_NAME" | wc -l
