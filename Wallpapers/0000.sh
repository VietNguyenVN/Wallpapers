#!/usr/bin/env bash

set -euo pipefail

DIR="${1:-.}"

# Find the highest existing number
max=-1
shopt -s nullglob

for f in "$DIR"/[0-9][0-9][0-9][0-9].*; do
  base="$(basename "$f")"
  num="${base%%.*}"
  if [[ "$num" =~ ^[0-9]{4}$ ]]; then
    ((num > max)) && max=$num
  fi
done

next=$((max + 1))

# Rename unnumbered files
for f in "$DIR"/*; do
  base="$(basename "$f")"

  # Skip directories
  [[ -d "$f" ]] && continue

  # Skip already-numbered files
  if [[ "$base" =~ ^[0-9]{4}\..+ ]]; then
    continue
  fi

  ext="${base##*.}"

  printf -v num "%04d" "$next"
  new="$DIR/$num.$ext"

  mv -- "$f" "$new"
  ((next++))
done

echo "Wallpaper numbering complete."
