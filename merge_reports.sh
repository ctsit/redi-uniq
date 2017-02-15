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

if [ ! -z ${NO_REPORT_FILE} ] && [ ! -z ${REPORT_MERGE_FILE} ] && [ ! -z ${REPORT_COPY_EXTENSION} ] && [ ! -z ${REPORT_DIRECTORY} ];
then
    python ${MY_DIR}/merge_reports.py ${REPORT_DIRECTORY} ${REPORT_COPY_EXTENSION} ${REPORT_MERGE_FILE} ${NO_REPORT_FILE}
else
    echo "Missing NO_REPORT_FILE, REPORT_MERGE_FILE, REPORT_COPY_EXTENSION, and REPORT_DIRECTORY in your config"
fi
