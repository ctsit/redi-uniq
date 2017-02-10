#!/usr/bin/env python

import pysftp
import sys
import os
# import time
import ConfigParser
import StringIO
from datetime import datetime

if len(sys.argv) > 1 and len(sys.argv) == 4:
    settings_ini = sys.argv[1]
    output_file_path = sys.argv[2]
    overwrite = sys.argv[3]

    # Set the overwrite flag to 'n' if it is anything but 'y'
    if overwrite is not 'y':
        overwrite = 'n'
else:
    print('2 arguments required: 1 = RED-I settings file location, 2 = Directory to store data file, 3 = Overwrite file (y or n)')
    exit()

settings_block_name = 'settings'
preserve_modified_time = True
# today = time.strftime("%Y%m%d%H%M")
new_data_file = output_file_path

def writeLog(message):
    timestamp = datetime.now().strftime('%Y-%m-%d:%H:%M:%S')
    sys.stdout.write(timestamp + ' - ' + message + '\n')

def saveFile(sftp_object, emr_data_file, new_data_file, preserve_modified_time):
    writeLog('Saving: ' + new_data_file)
    sftp.get(emr_data_file, preserve_mtime=preserve_modified_time)
    os.rename(emr_data_file, new_data_file)

if settings_ini and output_file_path:
    try:
        with open(settings_ini, 'r') as f:
            config_string = '[' + settings_block_name + ']\n' + f.read()

        buf = StringIO.StringIO(config_string)
        config = ConfigParser.ConfigParser()
        config.readfp(buf)

        emr_sftp_server_hostname = config.get(settings_block_name, 'emr_sftp_server_hostname')
        emr_sftp_server_username = config.get(settings_block_name, 'emr_sftp_server_username')
        emr_sftp_server_password = config.get(settings_block_name, 'emr_sftp_server_password')
        emr_sftp_project_name = config.get(settings_block_name, 'emr_sftp_project_name')
        emr_data_file = config.get(settings_block_name, 'emr_data_file')

        with pysftp.Connection(emr_sftp_server_hostname, username=emr_sftp_server_username, password=emr_sftp_server_password, port=22) as sftp:
            writeLog('SFTP Link: ' + emr_sftp_server_username + '@' + emr_sftp_server_hostname)
            writeLog('Remote Project: ' + emr_sftp_project_name)
            with sftp.cd(emr_sftp_project_name):
                new_data_file = output_file_path
                if os.path.isfile(new_data_file):
                    if overwrite == 'y':
                        writeLog('Overwriting: ' + new_data_file)
                        saveFile(sftp, emr_data_file, new_data_file, preserve_modified_time)
                    else:
                        writeLog('Preserving: ' + new_data_file)
                else:
                    saveFile(sftp, emr_data_file, new_data_file, preserve_modified_time)

    except Exception as e:
        print('Errors occured in collecting data file')
        print(e)
