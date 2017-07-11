#!/bin/bash
#writer:qiulibo7-10-17

#HOST=192.168.18.22
#USER=root
#PASS=')iBOK%e0QVtAT8'

#QUERY=`mysql -h$HOST -u$USER -p$PASS <<EOF
#    use vpn;
#    select * from vpnuser;
#    exit
#    EOF`
#echo $QUERY

#adduser
function Adduser()
{
	read -p "Please enter add user name: " name
	stty -echo
	read -p "Please enter user passwd: " pass
	stty echo
	echo
	ansible vpn -m shell -uroot -a "/scripts/AddVpnuser.sh $name $pass" 2>&1 >/dev/null
	if [ $? -eq 0 ];then
		echo "Add user success!"
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


#main
echo "please select operation:
[1] Adduser
[2] Deluser
"
read -p "---:" operation
case $operation in
"1")
	Adduser
	;;
"2")
	Deluser
	;;
*)
	echo "select error!"
	exit
	;;
esac
