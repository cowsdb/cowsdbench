#!/bin/bash

PROVIDER="${PROVIDER:-github}"
MACHINE="${MACHINE:-2vCPU_7GB}"

cat log.txt | grep -P '^\d|Killed|Segmentation' | sed -r -e 's/^.*(Killed|Segmentation).*$/null\nnull\nnull/' | awk '{ if (i % 3 == 0) { printf "[" }; printf $1; if (i % 3 != 2) { printf "," } else { print "]," }; ++i; }' > dump.json 
RESULTS=$(cat dump.json)
rm -rf dump.json

mkdir -p results

VERSION=$(curl -S http://localhost:8123?query=SELECT version()")

echo '{
    "system": "CowsDB",
    "date": "'$(date +%F)'",
    "machine": "'$PROVIDER $MACHINE'",
    "cluster_size": "serverless",
    "comment": "'$VERSION'",
    "tags": ["C++", "column-oriented", "embedded", "github"],
    "load_time": 0,
    "data_size": '0',
    "result": [
      '$(echo $RESULTS | head -c-2)'
    ]
}
' > "results/${PROVIDER}.${MACHINE}.json"
