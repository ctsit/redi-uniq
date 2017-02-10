#!/usr/bin/env bash

# Argument 1: a local config.ini file for redi-uniq

MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${MY_DIR}/get_config.sh

# Check to make sure that a local settings.ini file was passed as argument 1
if [ ! -z ${MAIN_INI_FILE} ];
then
        source ${MAIN_INI_FILE}
else
        echo "Arg 1 should be a config.ini file"
        exit
fi

if [ ! -z ${USER_DATA_DIRECTORY} ] && [ ! -z ${RAW_FILE} ];
then
    # This counts for the one header line in the raw file
    TOTAL=1

    for participant_file in `ls ${USER_DATA_DIRECTORY}/*.txt`;
    do
            echo "Getting line count from participant: ${participant_file}"
            line_count=`cat ${participant_file} | wc -l`

            # Add the line_count for this file to the total
            TOTAL=$[${TOTAL}+${line_count}]

            # Remove a count for the header line that is in each participant file
            TOTAL=$[${TOTAL}-1]
    done

    # Get the line count of the raw_file, which is the full dataset from the EMR
    RAW_LINES=`cat ${RAW_FILE} | wc -l`
    DIFFERENCE=$[${RAW_LINES}-${TOTAL}]

    echo "Raw Line Count: "${RAW_LINES}
    echo "Combined Micro Line Count: "${TOTAL}
    echo "Difference: "${DIFFERENCE}
else
    echo "Missing USER_DATA_DIRECTORY or RAW_FILE in your config"
fi
