#!/bin/bash
#writer:qiulibo7-10-17


#adduser
function Adduser()
{
	read -p "Please enter add user name: " name
	read -p "Please enter user comment:" comment
#	stty -echo
#	read -p "Please enter user passwd: " pass
#	stty echo
#	echo
	pass=`openssl rand -base64 12`
	ansible vpn -m shell -uroot -a "/scripts/AddVpnuser.sh $name $pass $comment" 2>&1 >/dev/null
	if [ $? -eq 0 ];then
		echo "Add user success!"
		echo "name:$name pass:$pass"
	else
		echo "fail!"
		exit
	fi
}

#deluser
function Deluser()
{
	read -p "Please enter del user name: " name
	ansible vpn -m shell -uroot -a "/scripts/DelVpnuser.sh $name" 2>&1 >/dev/null
	if [ $? -eq 0 ];then
		echo "Del user success!"
	else
		echo "fail! please check..."
		exit
	fi	
}

#queryuser
function Queuser()
{
	ULIST=`ansible vpn -m shell -uroot -a "/scripts/QueVpnuser.sh"|tail -n +3`
	if [ $? -eq 0 ];then
		echo $ULIST
	else
		echo "Query failed! Pls check..."
		exit
	fi
}

#main
echo -e "please select operation:
\033[32m [1] Adduser \033[0m
\033[31m [2] Deluser \033[0m
\033[33m [3] Queuser \033[0m
"
read -p "Pls enter your operation[1|2|3]:" operation
case $operation in
"1")
	Adduser
	;;
"2")
	Deluser
	;;
"3")
	Queuser
	;;
*)
	echo "select error!"
	exit
	;;
esac
