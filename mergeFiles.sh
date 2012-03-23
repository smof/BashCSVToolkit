#!/bin/bash
#File Merge and Appender 0.1
#Simon Moffatt 20/02/12

function merge() {
	
	mkdir orig/
	mv *.* orig/
	cat orig/*.* >> merged_file.dat
	echo "Done merging...!"
	exit
}

echo "This will merge all files in current directory, backing up origs.  Cont?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) merge;;
        No ) exit;;
    esac
done






