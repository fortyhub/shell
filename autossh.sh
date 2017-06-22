#!/bin/bash
#writer:qlb



cat /Users/qiulibo/shell/password.lst|awk -F: '{print $1}'
read -p "请输入host-ip的最后一段:" ip
host=192.168.2.$ip
user=$(cat /Users/qiulibo/shell/password.lst|grep $host|awk -F: '{print $2}')
echo $user
pass=$(cat /Users/qiulibo/shell/password.lst|grep $host|awk -F: '{print $3}')
echo $pass

/usr/bin/expect <<EOF
set time 30
spawn ssh -p22 $user@$host
expect {
"*password:{ send "$pass\r"}"
}
expect "*~" 
interact
EOF
