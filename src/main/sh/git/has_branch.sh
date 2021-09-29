#!/usr/bin/env bash

branch=$1

git ls-remote --heads origin "$branch" | wc -l
