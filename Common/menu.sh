#!/bin/sh
#menu
#set the date, user and hostname up

MYDATE=`date +%d/%m/%Y`
THIS_HOST=`hostname -s`
USER=`whoami`

#loop forever
while :
do
	#clear the screen
	tput clear
	#here documents starts here
	cat <<EOF
	----------------------------------------------------------------
	User:$USER	Host:$THIS_HOST	Date:$MYDATE
	----------------------------------------------------------------
			1: List files in current directory
			2: Use the vim editor
			3: See who is on the system
			H: Help screen
			Q: Exit Menu
	----------------------------------------------------------------
EOF

	#here document finished
	echo -e -n "\tYour Choice [1,2,3,H,Q] >"
	read CHOICE
		case $CHOICE in 
		1) ls
		;;
		2) vim
		;;
		3) who
		;;
		H|h)
		#use a here document for the help screen
		cat <<MAYDAY
		This is the help screen, nothing here yet to help you!
MAYDAY
		;;
		Q|q) exit 0
		;;
		*) echo -e "\t\007unknown user response"
		;;
		esac
	echo -e -n "\tHit the return key to continue"
	read DUMMY
done
