#!/bin/bash

TRIES=3
QUERY_NUM=1
cat queries.sql | while read query; do
    # curl -G -s --data-urlencode "query=SYSTEM DROP FILESYSTEM CACHE" http://test:test@localhost:8123

    echo -n "["
    for i in $(seq 1 $TRIES); do
        RES=$(curl -G -s --data-urlencode "query=$query" http://test:test@localhost:8123)
        [[ "$?" == "0" ]] && echo -n "${RES}" || echo -n "null"
        [[ "$i" != $TRIES ]] && echo -n ", "

        echo "${QUERY_NUM},${i},${RES}" >> result.csv
    done
    echo "],"

    QUERY_NUM=$((QUERY_NUM + 1))
done
