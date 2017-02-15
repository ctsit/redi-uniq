#!/usr/bin/env bash

# Argument 1: a local config.ini file for redi-uniq

MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SAMPLE_CONFIG_DIRECTORY=${MY_DIR}/samples/configs

read -p "Would you like to create a new config [y/N]? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]];
then
    echo "Making a new uniq config file"

    cp ${SAMPLE_CONFIG_DIRECTORY}/config.example.ini ./uniq.ini
    cp ${SAMPLE_CONFIG_DIRECTORY}/config_cron.example.ini ./uniq_cron.ini
else
    read -p "Would you like to test an existing uniq config [y/N]? " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]];
    then
        echo "Testing an existing config file"
        source ${MY_DIR}/get_config.sh
    else
        echo "Doing another future config option....."
    fi
fi
