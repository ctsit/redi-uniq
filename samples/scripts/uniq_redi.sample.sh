#!/usr/bin/env bash
/home/redi/prod/redi_0_15_4/bin/redi -c ${PROJECT_ROOT} -k -f ${USER_DATA_DIRECTORY}/${id}.txt --datadir ${USER_DATA_DIRECTORY}/${id}/ --skip-blanks ${DRY_RUN_FLAG} > ${INDIVIDUAL_RUN_LOG} 2>&1
