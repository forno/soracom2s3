#!/bin/sh
set -eu

find -type f | while read file
do
  mv "$file" "$file.bak"
  data_converter < "$file.bak" > "$file"
done
