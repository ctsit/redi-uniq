#!/usr/bin/env bash

# Argument 1: a local config.ini file for redi-uniq
# Argument 2: live or dry, depending on how you want to run RED-I

MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${MY_DIR}/get_config.sh

# Check to make sure that a local settings.ini file was passed as argument 1
# Argument 2 is not checked because it will default to a DRY RUN setting if not passed
if [ ! -z ${MAIN_INI_FILE} ];
then
        source ${MAIN_INI_FILE}
		DRY_RUN=${2}
else
	echo "Arg 1 should be a config.ini file, Arg 2 should be live or dry (defaults to dry)"
	exit
fi

# Ask the user if they have verified their RED-I settings.ini file is configured to point at
# a DEV or PROD REDCap instance
read -p "Have you checked [${PROJECT_ROOT}/settings.ini] to verify your REDCap is dev or prod [y/N]? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]];
then
	echo
	RUN_TYPE=dry
	if [ "${DRY_RUN}" == "live" ];
	then
		RUN_TYPE=LIVE
	else
		RUN_TYPE=DRY
		DRY_RUN_FLAG="-d"
	fi

    echo "Attempting ${RUN_TYPE} run in [${PROJECT_ROOT}]"
	if [ ! -z ${UNIQUE_FILE} ] && [ ! -z ${PROJECT_ROOT} ] && [ ! -z ${USER_DATA_DIRECTORY} ] && [ ! -z ${CURRENT_RUN_FILE} ];
	then

		if [ -z ${USER_DATA_DIRECTORY} ];
		then
			USER_DATA_DIRECTORY=${PROJECT_ROOT}/data
		fi

		# Do a pushd to run from the directory where the project root is found
        if [ -d ${PROJECT_ROOT} ];
        then
            # Note in the overall log that this has begun
            ALL_RUNS_CURRENT_RUN_LOG=${USER_DATA_DIRECTORY}/${CURRENT_RUN_FILE}

            # Start an overall log file to track the runs as a whole
            this_date=`date +"%Y-%m-%d %H:%M:%S"`
            echo "---${this_date}---" > ${ALL_RUNS_CURRENT_RUN_LOG}
    		pushd ${PROJECT_ROOT}/
    		for id in `cat ${UNIQUE_FILE}`;
    		do
                this_date=`date +"%Y-%m-%d %H:%M:%S"`
                INDIVIDUAL_RUN_LOG=${USER_DATA_DIRECTORY}/${id}/${CURRENT_RUN_FILE}
    			echo -e "${this_date} - Starting New Run: ${id} -> ${RUN_TYPE}" >> ${ALL_RUNS_CURRENT_RUN_LOG}
                echo -e "${this_date} - Logged to: ${INDIVIDUAL_RUN_LOG}" >> ${ALL_RUNS_CURRENT_RUN_LOG}

                # Create the output directory for this subject
                mkdir -p ${USER_DATA_DIRECTORY}/${id}/

                # Start a log file for this run
                echo -e "Starting Individual Log: ${id} at ${this_date}" > ${INDIVIDUAL_RUN_LOG}

                # It looks like the preprocs are re-writing the dates
                # TODO: determine what the heck happens if this doesn't happen
                echo -e "Copy the user's data file over the root raw file to keep the preprocs in line"
                cp ${USER_DATA_DIRECTORY}/${id}.txt ${RAW_FILE}

                # Run RED-I from it's virtualenv location
    			/home/redi/prod/redi_0_15_4/bin/redi -c ${PROJECT_ROOT} -k -f ${USER_DATA_DIRECTORY}/${id}.txt --datadir ${USER_DATA_DIRECTORY}/${id}/ --skip-blanks ${DRY_RUN_FLAG} > ${INDIVIDUAL_RUN_LOG} 2>&1
    		done
    		popd
        else
            echo "No such directory [${PROJECT_ROOT}]"
        fi
	else
		echo "Your run was not configured properly, did you even look at your local config.ini file?"
	fi
else
	echo "You should probably verify that settings.ini does not point to a PROD server unless you mean to!"
    echo 'If you are getting this line in a cron job, you did not echo "y" into the script'
fi
