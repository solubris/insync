#!/usr/bin/env bash

set -eo pipefail

SRC_PATH="$1"; shift
DST_PATH="$1"; shift
files=($*)

for f in ${files[*]}; do
  # TODO can't handle if file='.'
  rm -rf "$DST_PATH/$f"

  if [ -e "$SRC_PATH/$f" ]; then
    echo "copying file to dst: $f"
    if [[ $f =~ '/' ]]; then
      fPath="${f%/*}"
      echo "creating path: $fPath"
      mkdir -p "$DST_PATH/$fPath"
    fi
    cp -r "$SRC_PATH/$f" "$DST_PATH/$f"
#    cd "$DST_PATH"; git add "$f"
#  else
#    echo "file doesn't exist in src, removing from dest: $f"
  fi
done

cd "$DST_PATH"; git add .
