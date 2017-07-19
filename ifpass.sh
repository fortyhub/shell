#!/bin/bash
#ifpass

#set the variables to false
INVALID_USER=yes
INVALID_PASSWD=yes

#save the current stty settings
SAVEDSTTY=`stty -g`

echo "You are logging into a sensitive area"
echo -n "Enter your ID name:"
read NAME

#hide the characters typed in
stty -echo
echo "Enter your password:"
read PASSWORD
#back on again
stty $SAVEDSTTY
if [ "$NAME" == "dave" ] || [ "$NAME" == "pauline" ];then
INVALID_USER=no
fi

if [ "$PASSWORD" == "mayday" ];then
INVALID_PASSWD=no
fi

if [ "$INVALID_USER" == "YES" -o "$INVALID_PASSWD" == "yes" ];then
echo "`basename $0 :` Sorry wrong password or userid"
exit 1
fi

echo "correct user id and password given"
