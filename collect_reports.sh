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

if [ ! -z ${UNIQUE_FILE} ] && [ ! -z ${USER_DATA_DIRECTORY} ] && [ ! -z ${OUTPUT_DIRECTORY} ] && [ ! -z ${REPORT_FILE} ] && [ ! -z ${NO_REPORT_FILE} ] && [ ! -z ${REPORT_DIRECTORY} ];
then
    if [ -f ${NO_REPORT_FILE} ];
    then
        echo "Removing old NO_REPORT_FILE [${NO_REPORT_FILE}]"
        rm ${NO_REPORT_FILE}
    fi

    if [ ! -d ${REPORT_DIRECTORY} ];
    then
        mkdir -p ${REPORT_DIRECTORY}
    fi

    for id in `cat ${UNIQUE_FILE}`;
    do
        CURRENT_REPORT_PATH=${USER_DATA_DIRECTORY}/${id}/${OUTPUT_DIRECTORY}/${REPORT_FILE}
        MOVE_REPORT_TO_PATH=${REPORT_DIRECTORY}/${id}_${REPORT_COPY_EXTENSION}
        echo "Attempting to move [${CURRENT_REPORT_PATH}] to [${MOVE_REPORT_TO_PATH}]"
    	cp ${CURRENT_REPORT_PATH} ${MOVE_REPORT_TO_PATH} 2>> ${NO_REPORT_FILE}
    done

    NO_REPORT_TMP_FILE=${NO_REPORT_FILE}.tmp
    if [ -f ${NO_REPORT_FILE} ];
    then
        echo "Collecting the subject ids that did not have reports in their data directory"
        grep -Eo '[0-9]{3}\-[0-9]{4}' ${NO_REPORT_FILE} > ${NO_REPORT_TMP_FILE}
        echo "Renaming the [${NO_REPORT_TMP_FILE}] to [${NO_REPORT_FILE}]"
        mv ${NO_REPORT_FILE}.tmp ${NO_REPORT_FILE}
    else
        echo "Missing NO_REPORT_FILE from config"
    fi
else
	echo "No UNIQUE_FILE, USER_DATA_DIRECTORY, OUTPUT_DIRECTORY, REPORT_FILE, NO_REPORT_FILE, or REPORT_DIRECTORY in your config"
fi
