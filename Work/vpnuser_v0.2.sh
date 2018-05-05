#!/bin/bash
#writer:qiulibo17/09/22
#version:v0.2


HOST=192.168.18.22
USER=vpnadmin
PASS='@@lingtouniao@@'


#adduser
function Adduser()
{
read -p "Please enter add user name: " name
#stty -echo
#read -p "Please enter user passwd: " pass
#stty echo
#echo
pass=`openssl rand -base64 12`
mysql -h$HOST -u$USER -p$PASS <<EOF 2>/dev/null
use vpn;
insert into vpnuser values('$name',password('$pass'),'1');
exit
EOF

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
mysql -h$HOST -u$USER -p$PASS<<EOF 2>/dev/null
use vpn;
delete from vpnuser where name='$name';
exit
EOF

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
mysql -h$HOST -u$USER -p$PASS <<EOF 2>/dev/null
use vpn;
select name from vpnuser;
exit
EOF

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