#!/usr/bin/env bash

# This should be the path to your cron's config file
source ${1}

# This script gets the EMR data from the SFTP server
if [ "${GET_EMR}" == "yes" ];
then
    bash ${SCRIPT_PATH}/get_emr.sh ${CONFIG_PATH}
fi

# This script gets the EMR data from the SFTP server
# then the filter is run based on this flag
if [ "${RUN_RAW_FILTER}" == "yes" ];
then
    bash ${SCRIPT_PATH}/filter_raw.sh ${CONFIG_PATH}
fi

# This generates the unique files for individual runs
bash ${SCRIPT_PATH}/get_unique.sh ${CONFIG_PATH}

# The echo passes y into the question about your config that is asked
# with a command line run of this script
# Given "y", a config file, and a run_flag, this runs RED-I
echo "y" | bash ${SCRIPT_PATH}/run_redi.sh ${CONFIG_PATH} ${RUN_FLAG}

# This is the post run, report collector
bash ${SCRIPT_PATH}/collect_reports.sh ${CONFIG_PATH}
