#!/usr/bin/env bash

MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ -z ${1} ];
then
    read -ep "Path to redi-uniq config file: " MAIN_INI_FILE
else
    MAIN_INI_FILE=${1}
fi

if [ ! -z ${MAIN_INI_FILE} ];
then
    echo -e "${MAIN_INI_FILE}" >> ${MY_DIR}/.last_uniq_config
    export MAIN_INI_FILE
else
    echo "No config path specified"
    exit
fi
