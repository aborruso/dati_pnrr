#!/bin/bash

set -x
set -e
set -u
set -o pipefail

folder="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$folder"/processing

if [ -d "$folder"/../rill ]; then
  rm -rf "$folder"/../rill
fi

mkdir -p "$folder"/../rill

cd "$folder"/../rill
rill init

find ../dati -type f -iname "*.parquet" -print0 | while IFS= read -r -d '' file; do
  rill source add "$file"
done
