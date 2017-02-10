#!/usr/bin/env python

import sys
import csv
from datetime import datetime


def writeLog(message):
    timestamp = datetime.now().strftime('%Y-%m-%d:%H:%M:%S')
    sys.stdout.write(timestamp + ' - ' + message + '\n')

if len(sys.argv) > 1 and len(sys.argv) == 4:
    raw_file = sys.argv[1]
    output_file = sys.argv[2]
    column_of_id = sys.argv[3]
else:
    print('You are missing one of 3 parameters, 1 = raw file location, 2 = file to output ids, 3 = column where the id is located')

if raw_file and output_file and column_of_id:
    uniqueids = []
    csv.register_dialect(
        'mydialect',
        delimiter=',',
        quotechar='"',
        doublequote=True,
        skipinitialspace=True,
        lineterminator='\r\n',
        quoting=csv.QUOTE_MINIMAL)

    # Another dialect that has worked is csv.excel

    writeLog('Opening: ' + output_file)
    with open(output_file, 'w') as my_output_file:
        writeLog('Saving: ' + raw_file)
        with open(raw_file, 'rb') as my_csv_file:
            # I removed this for now because it seems to convert dates
            # to a different format on it's own (TODO: figure out what it does)
            # mydialect = csv.Sniffer().sniff(my_csv_file.read(2048))
            # my_csv_file.seek(0)
            the_data = csv.reader(my_csv_file, dialect='mydialect')
            row_count = 0
            for row in the_data:
                if row_count > 0:
                    this_id = row[int(column_of_id)]
                    if this_id not in uniqueids:
                        writeLog('Writing: ' + this_id + ' to uniqueids')
                        uniqueids.append(this_id)
                        my_output_file.write(this_id + '\n')
                row_count += 1

    writeLog('Sorting: ' + output_file)
    with open(output_file, 'r') as my_output_file:
        lines = sorted(set([word for line in my_output_file for word in line.split()]))

    writeLog('Storing: ' + output_file)
    with open(output_file, 'w') as my_output_file:
        for line in lines:
            my_output_file.write("%s\n" % line)
