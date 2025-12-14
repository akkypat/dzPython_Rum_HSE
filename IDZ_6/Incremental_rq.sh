#!/bin/bash
# usage ./Incremental_rq.sh 2025-12-06

if [ -z "$1" ]; then
    LOAD_DATE=$(date +%Y-%m-%d)
else
    LOAD_DATE=$1
fi

echo "use $LOAD_DATE for loading"

# replace date and exec 
sed "s/LOAD_DATE/$LOAD_DATE/g" Incremental_rq.sql | docker exec -i trino trino

echo "done"