#!/usr/bin/env bash

set -eo pipefail

SRC_PATH="$1"; shift
files=($*)

for f in ${files[*]}; do
  # TODO can't handle if file='.'
  echo "removing entry from dst: $f"
  rm -rf "$f"

  if [ -e "$SRC_PATH/$f" ]; then
    echo "copying entry to dst: $f"
    if [[ $f =~ '/' ]]; then
      fPath="${f%/*}"
      echo "creating path: $fPath"
      mkdir -p "$fPath"
    fi
    cp -r "$SRC_PATH/$f" "$f"
  fi
done

git add .
