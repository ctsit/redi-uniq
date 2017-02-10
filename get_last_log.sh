#!/usr/bin/env bash

# Argument 1: a local config.ini file for redi-uniq
# Argument 2: a subject id for the project you are working with

MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${MY_DIR}/get_config.sh

# Check to make sure that a local settings.ini file was passed as argument 1
if [ ! -z ${MAIN_INI_FILE} ];
then
        source ${MAIN_INI_FILE}
        ID=${2}
else
        echo "Arg 1 should be a config.ini file, Arg 2 should a subject id"
        exit
fi

if [ ! -z ${USER_DATA_DIRECTORY} ] && [ ! -z ${ID} ] && [ ! -z ${LOG_DIRECTORY} ];
then
    LAST_LOG_PATH=`ls -t ${USER_DATA_DIRECTORY}/${ID}/${LOG_DIRECTORY}/*.log`
    read -p "What part of the log would you like to see? [0=just show me the path, 1=tail the file, 2=cat the whole file, 3=less the file, 4=get the last 10 lines] " -n 1 -r
    if [[ $REPLY == "1" ]];
    then
        tail -f ${LAST_LOG_PATH}
    elif [[ $REPLY == "2" ]];
    then
        cat ${LAST_LOG_PATH}
    elif [[ $REPLY == "3" ]];
    then
        less ${LAST_LOG_PATH}
        clear
    elif [[ $REPLY == "4" ]];
    then
        cat ${LAST_LOG_PATH} | tail -n10
    else
        echo "LAST LOG PATH: ${LAST_LOG_PATH}"
    fi
else
    echo "No USER_DATA_DIRECTORY or LOG_DIRECTORY in your config and/or no ID passed as Arg2"
fi
