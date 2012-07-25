#!/bin/bash
#Bash wrapper for various masking functions using TR
#Useful for anonymising sensitive data.  Note using rot13 twice on same dataset will return back to original format
#Part of my BashCSVToolkit - https://github.com/smof/BashCSVToolkit
#Simon Moffatt 25/07/12

#Data files
INPUT=data.dat
OUTPUT=anon.dat

#Column definitions.  Just expand based on data being read
COL1="Email"
COL2="sammaccountname"
COL3="EmployeeID"
COL4="Title"
COL5="City"
COL6="Department"

#Set input/output field separator
OLDIFS=$IFS
IFS=,

#Check Input file exists..
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }


# M A S K I N G   F U N C T I O NS ###########################################################################
#Basically just looked at tr --help and added abit of imagination...

#One way masker replacing vowel chars with -.
function mask_vowels {

	vowels=aeiou  				#Eg. SimonMoffatt = S-m-nM-ff-tt

	echo $1 | tr "$vowels" -

}


#One way masker replacing constanants -.
function mask_const {

	const=abcdfghjklmnpqrstvwxyz		#Eg. SimonMoffatt = Si-o-Mo--a--

	echo $1 | tr "$const" -

}

#One way masker replacing random chars with -.
function mask_random {

	random=siktmqj				#Eg. SimonMoffatt = S--onMoffa--

	echo $1 | tr "$random" -

}

#One way masker replacing letters in string.  Eg. SimonMoffatt12345 becomes ------------12345
function mask_letters {

		echo $1 | tr '[:alpha:]' -
}

#One way masker replacing numbers in string.  Eg. SimonMoffatt12345 becomes SimonMoffatt-----
function mask_numbers {

		echo $1 | tr '[:digit:]' -
}


#Weak encryption using basic rotary13 subsitution cipher.  a-->m, b-->n, c-->o.  Running twice will send m-->a, b-->n, c-->o
function rot13 {
		
		echo $1 | tr '[N-ZA-Mn-za-m5-90-4]' '[A-Za-z0-9]'
}


#Slightly tougher to crack subsitution cipher with chosen key of random alphabet
function subt_cipher {
	
	key=ETAOINSHRDLUBCFGJMQPVWZYXK #must use all letters in alphabet in any order.  chars not in alphabet left unchanged

	echo $1 | tr "a-z" "A-Z" | tr "A-Z" "$key"
}

#Reverses subt_cipher
function reverse_subt_cipher {
	
	key=ETAOINSHRDLUBCFGJMQPVWZYXK #must use all letters in alphabet in any order.  chars not in alphabet left unchanged

	echo $1 | tr "$key" "A-Z"
}


#One way scrambler using a phrase.  Will leave whitespace etc
function scrambler {

	scrambler_phrase="quite a long phrase that can obfuscate"
	echo $1 | tr "a-z" "$scrambler_phrase"

}


# M A S K I N G   F U N C T I O NS ###########################################################################





#Creates header as anon output file might look a little confusing...
echo "$COL1,$COL2,$COL3,$COL4,$COL5,$COL6" > $OUTPUT

#Read the CSV file
while read COL1 COL2 COL3 COL4 COL5 COL6
	do
		echo "$(vowel_masker $COL1),$(const_masker $COL2),$COL3,$COL4,$COL5,$COL6" >> $OUTPUT

	done < $INPUT

IFS=$OLDIFS







