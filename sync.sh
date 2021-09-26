#!/usr/bin/env bash

SRC_PATH=$1
shift
DST_PATH=$1
shift
files=($*)

for f in ${files[*]}; do
  if [ -e "$SRC_PATH/$f" ]; then
    echo "copying file to dst: $f"
    cp "$SRC_PATH/$f" "$DST_PATH/"
    cd "$DST_PATH"; git add "$f"
  else
    echo "file doesn't exist in src, removing from dest: $f"
    rm -f "$DST_PATH/$f"
  fi
done

cd "$DST_PATH"; git add .
