#!/usr/bin/env python

import re
import sys
# from optparse import OptionParser
# import inspect
import json

input_file_path = sys.argv[1]
output_file_path = sys.argv[2]

# Get the rules scripts
rules_lib_path = sys.argv[3]
sys.path.append(rules_lib_path)
from myrules import myrules

rules_file_path = sys.argv[4]

print('Input Path: ' + input_file_path)
print('Output Path: ' + output_file_path)
print('Rules Library: ' + rules_lib_path)
print('Rules Path: ' + rules_file_path)

# Possible to use for collecting available methods from a class
# methods_available = inspect.getmembers(myrules)

def runRule(rule_name, input_value, values):
    print('Running: ' + rule_name)
    data = getattr(myrules, rule_name)(input_value, values)
    return data

with open(rules_file_path, 'r') as rules_file:
    data = rules_file.read()
    rule_data = json.loads(data)

with open(input_file_path, 'r') as input_file:
    input_file_data = input_file.read()
    for rule in rule_data:
        rule_name = rule['name']
        rule_values = rule['values']

        input_file_data = runRule(rule_name, input_file_data, rule_values)

with open(output_file_path, 'w') as output_file:
    output_file.write(input_file_data)
