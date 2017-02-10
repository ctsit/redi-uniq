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

if [ ! -z ${PROJECT_ROOT} ] && [ ! -z ${RAW_FILE} ];
then
    echo "Collecting EMR data from the SFTP server"
    python ${MY_DIR}/get_emr.py ${PROJECT_ROOT}/settings.ini ${RAW_FILE} y
else
    echo "Missing PROJECT_ROOT and/or RAW_FILE in your config"
fi
