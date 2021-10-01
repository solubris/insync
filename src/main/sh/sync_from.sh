#!/usr/bin/env bash

set -eo pipefail

from="$1"; shift
files=($*)

for f in ${files[*]}; do
  # TODO can't handle if file='.'
  echo "removing entry from dst: $f"
  rm -rf "$f"

  if [ -e "$from/$f" ]; then
    echo "copying entry to dst: $f"
    if [[ $f = */* ]]; then
      fPath="${f%/*}"
      echo "creating path: $fPath"
      mkdir -p "$fPath"
    fi
    cp -r "$from/$f" "$f"
  fi
done
