#!/usr/bin/env bash

set -eo pipefail

src_path="$1"; shift
files=($*)

for f in ${files[*]}; do
  # TODO can't handle if file='.'
  echo "removing entry from dst: $f"
  rm -rf "$f"

  if [ -e "$src_path/$f" ]; then
    echo "copying entry to dst: $f"
    if [[ $f = */* ]]; then
      fPath="${f%/*}"
      echo "creating path: $fPath"
      mkdir -p "$fPath"
    fi
    cp -r "$src_path/$f" "$f"
  fi
done
