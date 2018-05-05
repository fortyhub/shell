#!/bin/bash
#本脚本用于ltn服务的远程控制


ssh_key=/scripts/publish/id_publish

#选择服务器、项目
function putinfo(){
echo "请选择服务器"
echo "153服务:        |  179服务:   
ltn-app-account |  ltn-app-account
ltn-pc-product  |  ltn-pc-product
uam-act-provider|
uam-service-rest|
ltn-market      |
open-trade      |"

read -p "[153|179]:" SERVER
read -p "请输入服务名:" PROJECTNAME
read -p "请输入您的操作[restart|stop]" OPERATION
}

#判断推送版本
function __version(){
case $SERVER in
"153"|"179")
	echo `ssh -i $ssh_key root@10.47.52.$SERVER \
	"ls -l /data/service-online/$PROJECTNAME/current_version" \
	|awk '{print $11}'|awk -F"/" '{print $5}'`
	
	raed -p "请确认是否为最新推送版本[y|n]:" SURE
	
	if [ $SURE == "y" -o $SURE == "Y" ];then
		continue
	else
		exit 2
	fi
;;
*)
echo "no this server!"
exit 1
;;
esac
}	

#远程启动
function __startSer(){
	echo `ssh -i $ssh_key root@10.47.52.$SERVER \
	"/scripts/service/startService.sh $PROJECTNAME $OPERATION"`
}

#main
putinfo
__version
__startSer
