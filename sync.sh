#!/usr/bin/env bash

SRC_PATH=$1
shift
DST_PATH=$1
shift
files=($*)

for f in ${files[*]}; do
  echo checking "$f"
  cp "$SRC_PATH/$f" "$DST_PATH/"
done
