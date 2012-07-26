#!/bin/bash
#Bash wrapper for various masking functions using TR
#Useful for anonymising sensitive data.  Note using rot13 twice on same dataset will return back to original format
#Part of my BashCSVToolkit - https://github.com/smof/BashCSVToolkit
#Simon Moffatt 25/07/12

#Current List of Masks
#mask_vowels - hides any vowels in a string with a dash
#mask_cons - hides any consonants in a string with a dash
#mask_random - hides any random alpha's in a string with a dash
#rot13 - rotates alphabet 13 places
#scrambler - subtitution based on a phrase
#mask_middle - hides all bar middle 3 chars of a string with a dash
#mask_credit_card - hides first 12 chars of the string with a dash
#mask_letters - hides all letters in an alphanum with a dash
#mask_numbers - hides all numbers in an alphanum with a dash
#subs_cipher - key based substituion cipher



#Data files
INPUT=data.dat
OUTPUT=anon.dat

#Column definitions.  Just expand based on data being read
COL1="Email"
COL2="LANID"
COL3="EmployeeID"
COL4="Phone"

#Set input/output field separator
OLDIFS=$IFS
IFS=,

#Check Input file exists..
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }


# M A S K I N G   F U N C T I O N S ###################################################################################################
#Basically just looked at tr --help and added abit of imagination...

#One way masker replacing vowel chars with -.
function mask_vowels {

	vowels=aeiou  				#Eg. SimonMoffatt = S-m-nM-ff-tt

	echo $1 | tr "$vowels" -

}


#One way masker replacing consonants -.
function mask_cons {

	cons=abcdfghjklmnpqrstvwxyz		#Eg. SimonMoffatt = Si-o-Mo--a--

	echo $1 | tr "$cons" -

}

#One way masker replacing random chars with -.
function mask_random {

	random=aeiouslmnthgd				#Eg. SimonMoffatt = S--onMoffa--

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
function subs_cipher {
	
	key=ETAOINSHRDLUBCFGJMQPVWZYXK #must use all letters in alphabet in any order.  chars not in alphabet left unchanged

	echo $1 | tr "a-z" "A-Z" | tr "A-Z" "$key"
}

#Reverses subs_cipher
function reverse_subs_cipher {
	
	key=ETAOINSHRDLUBCFGJMQPVWZYXK #must use all letters in alphabet in any order.  chars not in alphabet left unchanged

	echo $1 | tr "$key" "A-Z"
}


#One way scrambler using a phrase.  Will leave whitespace etc
function scrambler {

	scrambler_phrase="quite a long phrase that can obfuscate"
	echo $1 | tr "a-z" "$scrambler_phrase"

}

#Masks all bar middle 3 chars of string
function mask_middle {

	string=$1

	#middle of 9char fixed length Eg. ---abc---
	echo "---${string:4:6}---" 

}


#Masks first 12 chars of a credit card or similar fixed length string
function mask_credit_card {

	string=$1

	#mask first 12 of 16 digit credit card Eg. ------------1234
	echo "------------${string:13}"

}


# M A S K I N G   F U N C T I O N S ###################################################################################################





#Creates header as anon output file might look a little confusing...
echo "$COL1,$COL2,$COL3" > $OUTPUT

#Read the CSV file
while read COL1 COL2 COL3 COL4
	do
		echo "$(rot13 $COL1),$(mask_credit_card $COL2),$(mask_numbers $COL3), $(rot13 $COL4)" >> $OUTPUT

	done < $INPUT

IFS=$OLDIFS







