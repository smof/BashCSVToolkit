#!/bin/bash
#Bash wrapper for basic sed line insert
#Simon Moffatt 04/04/12
#Takes 2 args - 1st = string to insert, 2nd = file or file pattern to work on

echo "Starting..."
echo ""

#Checks number of arguments being passed is higher than 2 (allows for multiple files)
if [ $# -lt 2 ]
 then
	echo "Oops!"
	echo "Needs atleast 2 args: ./insertLine.sh <string_to_insert> <filename_pattern>"
	echo "Eg. ./findReplace.sh \"new line\" letter.txt >> for single file"
	echo "Eg. ./findReplace.sh \"new line\" *.txt >> for multiple files matching pattern"
	echo ""
	exit 0
fi

#pick up the first arg as insert_string
insert_string=$1

#funky stuff to iterate over the file pattern.  works for single or multiple files being passed

#array of all command line args
ARGV=("$@")
#total number of expanded args which includes number of files matting pattern used in $2
ARGCount=${#ARGV[@]}

#start at 2 as anything above that is a file matching the expanded pattern.  the wildcard patten is expanded before being processed!
for ((i = 1; i < $ARGCount; i++))
do
	if [ -f "${ARGV[$i]}" ]
	then    

		sed -i_bkup "1i${insert_string}" "${ARGV[$i]}"
		echo "Done: ${ARGV[$i]}"		
	
	else
		echo "File not found: ${ARGV[$i]}"
	fi
done

echo ""
echo "All done, going to sleep... :)"

