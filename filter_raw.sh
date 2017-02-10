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

function listFiles() {
    echo "Showing all generated and parsed files in their current state"
    ls_flags=al
    ls -${ls_flags} ${RAW_FILE}
    md5 ${RAW_FILE}
    ls -${ls_flags} ${FILTERED_FILE}
    md5 ${FILTERED_FILE}
    ls -${ls_flags} $OLD_RAW_FILE
    md5 ${OLD_RAW_FILE}
}

if [ ! -z ${PROJECT_ROOT} ] && [ ! -z ${RAW_FILTER_PATH} ] && [ ! -z ${RAW_FILE} ] && [ ! -z ${FILTERED_FILE} ] && [ ! -z ${OLD_RAW_FILE} ];
then
    if [ -f ${RAW_FILE} ];
    then
        listFiles

        echo "Pre-filtering raw data [${RAW_FILE}], outputting to [${FILTERED_FILE}]"
        python ${MY_DIR}/filter_raw.py ${RAW_FILE} ${FILTERED_FILE} ${MY_DIR}/ ${RAW_FILTER_PATH}

        echo "Copying old raw file [${RAW_FILE}] to backup copy [${OLD_RAW_FILE}]"
        cp ${RAW_FILE} ${OLD_RAW_FILE}

        echo "Moving filtered file [${FILTERED_FILE}] to rename as original raw file name [${RAW_FILE}]"
        cp ${FILTERED_FILE} ${RAW_FILE}

        listFiles
    else
        echo "You are missing your raw_file, specified in config as [${RAW_FILE}]"
    fi
else
    echo "Missing PROJECT_ROOT, RAW_FILTER_PATH, RAW_FILE, FILTERED_FILE, or OLD_RAW_FILE in your config"
fi
