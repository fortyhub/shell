#!/bin/bash
#fun

function char_name(){
#char_name
#to call:char_name string
#assion the argument across to new variable
_LETTERS_ONLY=$1
#use awk to test for characters only !
_LETTERS_ONLY=`echo $1|awk '{if($0~/[^a-z A-Z]/) print "1"}'`
if [ "$_LETTERS_ONLY" != "" ];then
#oops errors
return 1
else
#contains only chars
return 0
fi
}

function name_error(){
#name_error
#display an error message
echo "$@ contains errors, it must contain only letters"
}

while :
do
	echo -n "what is your first name :"
	read F_NAME
	if char_name $F_NAME
	then
	#all ok breakout
	break
	else
	name_error $F_NAME
	fi
done

while :
do
	echo -n "what is your surname :"
	read S_NAME
	if char_name $S_NAME
	then
	#all ok breakout
	break
	else
	name_error $S_NAME
	fi
done
