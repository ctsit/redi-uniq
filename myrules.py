#!/usr/bin/env python
import re

class myrules:
    # Remove the ,"\n that is showing in component 1863 lines
    @staticmethod
    def rule_regex(input_value, values=["",""]):
        regex = re.compile(values[0])
        output_value = regex.sub(values[1], input_value)
        return output_value

    @staticmethod
    def rule_replace(input_value, values=['','']):
        output_value = input_value.replace(values[0], values[1])
        return output_value

    @staticmethod
    def rule_match_replace(input_value, value=['','']):
        if input_value == values[0]:
            output_value = values[1]
        else:
            output_value = input_value
        return output_value

    @staticmethod
    def rule_match_keep(input_value, value=['','']):
        if input_value == values[0]:
            output_value = input_value
        else:
            output_value = values[1]
        return output_value
