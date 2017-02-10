#!/usr/bin/env bash

RAW_SOURCE=${1}
USER_DIRECTORY=${2}
TOTAL=1

for raw_file in `ls ${USER_DIRECTORY}*.txt`;
do
        echo $raw_file
        line_count=`cat ${raw_file} | wc -l`
        TOTAL=$[${TOTAL}+${line_count}]
        TOTAL=$[${TOTAL}-1]
done

RAW_LINES=`cat ${RAW_SOURCE} | wc -l`
DIFFERENCE=$[${RAW_LINES}-${TOTAL}]

echo "Raw Line Count: "${RAW_LINES}
echo "Combined Micro Line Count: "${TOTAL}
echo "Difference: "${DIFFERENCE}
