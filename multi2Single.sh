#!/bin/bash
#AWK port of my Java StringCAT util.  Concatenation tool for merging multi-line records to single-line
#Simon Moffatt 27/02/12
#Takes 2 args - first is orig file, 2nd is output file.  Assumes orig data contains only 2 fields.

echo 'Starting...'

#Checks number of arguments being passed is 2
if [ $# -ne 2 ]
 then
	echo "Needs 2 args: ./stringCat.sh <orig_file> <output_file>"
	exit 0
fi

#awk command embedded with time to show resources
time awk '{a[$1]=a[$1]$2"|"}END{for(i in a)print i,a[i]}' $1 > $2

echo 'Done!'

