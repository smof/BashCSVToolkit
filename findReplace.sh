#!/bin/bash
#Bash wrapper for basic sed find and replace
#Simon Moffatt 23/03/12
#Takes 3 args - 1st = old string, 2nd = new string, 3rd = file or file pattern to work on

echo "Starting..."
echo ""

#Checks number of arguments being passed is higher than 2 (allows for multiple files)
if [ $# -lt 3 ]
 then
	echo "Oops!"
	echo "Needs atleast 3 args: ./findReplace.sh <old_string> <new_string> <filename_pattern>"
	echo "Eg. ./findReplace.sh smith jones letter.txt >> for single file"
	echo "Eg. ./findReplace.sh smith jones *.txt >> for multiple files matching pattern"
	echo ""
	echo "Special keyword: nothing"
	echo "Eg. ./findReplace.sh \\\" nothing file.txt >> replaces quotes with nothing - \"simon\" >> simon"
	exit 0
fi

#pick up the first two args and use as the pattern and new replacement
orig_string=$1
new_string=$2

#funky stuff to iterate over the file pattern.  works for single or multiple files being passed

#array of all command line args
ARGV=($@)
#total number of expanded args which includes number of files matting pattern used in $3
ARGCount=${#ARGV[@]}

#start at 2 as anything above that is a file matching the expanded pattern.  the wildcard patten is expanded before being processed!
for ((i = 2; i < $ARGCount; i++))
do
	if [ -f "${ARGV[$i]}" ]
	then    

		#perform a null check on replacement argument if replaceing something within "nothing"		
		if [ "$new_string" = "nothing" ]
		then	

			sed -i_bkup "s/${orig_string}//g" "${ARGV[$i]}"
			echo "Done: ${ARGV[$i]}"		

		else
	
			sed -i_bkup "s/${orig_string}/${new_string}/g" "${ARGV[$i]}"
			echo "Done: ${ARGV[$i]}"		

		fi
		
	else
		echo "File not found: ${ARGV[$i]}"
	fi
done

echo ""
echo "All done, going to sleep... :)"

