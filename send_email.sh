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

if [ ! -z ${REPORT_TEMPLATE_PATH} ] && [ ! -z ${REPORT_CONTENT_TYPE} ] && [ ! -z ${REPORT_MERGE_FILE} ] && [ ! -z ${REPORT_FROM_EMAIL} ] && [ ! -z ${REPORT_TO_EMAIL} ] && [ ! -z ${REPORT_EMAIL_SMTP_HOST} ];
then
    python ${MY_DIR}/send_email.py ${REPORT_MERGE_FILE} ${REPORT_TO_EMAIL} ${REPORT_FROM_EMAIL} ${REPORT_EMAIL_SMTP_HOST} ${REPORT_TEMPLATE_PATH} ${REPORT_CONTENT_TYPE}
else
    echo "Missing REPORT_TEMPLATE_PATH, REPORT_MERGE_FILE, REPORT_FROM_EMAIL, REPORT_TO_EMAIL, REPORT_CONTENT_TYPE, or REPORT_EMAIL_SMTP_HOST in your config"
fi
