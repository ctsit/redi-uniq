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

if [ ! -z ${USER_DATA_DIRECTORY} ] && [ ! -z ${CURRENT_RUN_FILE} ];
then
    ALL_RUNS_CURRENT_RUN_LOG=${USER_DATA_DIRECTORY}/${CURRENT_RUN_FILE}
    tail -f ${ALL_RUNS_CURRENT_RUN_LOG}
else
    echo "Missing USER_DATA_DIRECTORY or CURRENT_RUN_FILE in your config"
fi
