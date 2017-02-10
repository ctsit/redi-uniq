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

if [ ! -z ${UNIQUE_FILE} ] && [ ! -z ${USER_DATA_DIRECTORY} ] && [ ! -z ${RAW_FILE} ] && [ ! -z ${ID_COLUMN} ];
then
	python ${MY_DIR}/get_unique.py ${RAW_FILE} ${UNIQUE_FILE} ${ID_COLUMN}

    if [ ! -d ${USER_DATA_DIRECTORY} ];
    then
        mkdir -p ${USER_DATA_DIRECTORY}
    fi

	for id in `cat ${UNIQUE_FILE}`;
	do
		USER_FILE_PATH=${USER_DATA_DIRECTORY}/${id}.txt
        echo "Creating: ${USER_FILE_PATH}"
		head -n1 ${RAW_FILE} > ${USER_FILE_PATH}
		cat ${RAW_FILE} | grep ${id} >> ${USER_FILE_PATH}
	done
else
	echo "Missing UNIQUE_FILE, USER_DATA_DIRECTORY, RAW_FILE, or ID_COLUMN in your config"
fi
