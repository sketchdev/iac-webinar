#!/bin/bash

# function toLower
# Generates a lowercase version of the input string
#
# Call passing the string to be lowercased:
#  $ VAR_LOWER=$(toLower $INPUT_STR)
toLower () {
  echo ${1} | tr '[:upper:]' '[:lower:]'
}
