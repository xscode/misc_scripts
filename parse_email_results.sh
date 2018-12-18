#!/bin/bash

#===============================================================================
#title           :parse_email_results.sh
#description     :Parses Hashcat output files after searching for emails and 
#                :outputs several useful files.
#author		     :StuW
#date            :15-12-2018
#version         :0.2
#usage		     :parse_email_results.sh <hashcat output file>
#===============================================================================
  
SOURCE_FILE=$1

# if no source file supplied
if [ -z $SOURCE_FILE ]
then
    echo "Usage: " `basename "$0"` "<hashcat out file to parse>"
    exit
fi

# if supplied source file exists
if [ -e $SOURCE_FILE ]
then
    # Remove the hash - split the email into each part required and sort based on frequency, save that to the frequency files
    # then remove teh frequency counts to create teh raw username and domain files in highest frequency order.
    echo "Parsing " $SOURCE_FILE " usernames into usernames.txt..."
    cut -d':' -f2 $SOURCE_FILE | cut -s -d'@' -f1 | sort | uniq > usernames.txt
    echo "Parsing " $SOURCE_FILE " domains into domains.txt..."
    cut -d':' -f2 $SOURCE_FILE  | cut -d'@' -f2 | sort | sed 's/^M//g' | uniq> domains.txt
    echo "Parsing " $SOURCE_FILE " username frequencies into username_frequency.txt..."
    cut -d':' -f2 $SOURCE_FILE | cut -s -d'@' -f1 | sort | uniq -c | sed 's/^M//g' | sort -nr > username_frequency.txt
    echo "Parsing " $SOURCE_FILE " domain frequencies into domain_frequency.txt..."
    cut -d':' -f2 $SOURCE_FILE | cut -s -d'@' -f2 | sort | uniq -c | sed 's/^M//g' | sort -nr > domain_frequency.txt
    exit
fi

# if supplied source file doesn't exist
echo "File " $SOURCE_FILE " not found!"
