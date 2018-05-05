#!/bin/bash
#
# Script Start BossProjects;
# Last Edited by BaoJun@20170703;
#
# define vars
BACKUP_DIR=/home/ltn/deploy/backup-wars
UPLOAD_DIR=/home/ltn/deploy/upload-wars
WARFILE_DIR=/home/ltn/deploy/war-file
WEBSERVER_DIR=/home/ltn/deploy/web-server
PROJECT_NAME=$1
SERVICE_STATUS=$2
TIMESTAMP=`date +%F-%H-%M-%S`
#
#
# echo help
function __echohelp()
{
if [ "$PROJECT_NAME" == "" ];then
echo "PROJECT_NAME lists:
[1]  | boss-custom 	| 18203
[2]  | boss-market 	| 18204
[3]  | boss-crm 	| 18201
[4]  | boss-fund 	| 18202
[5]  | boss-report 	| 18205
[6]  | cas-server 	| 16666
[7]  | workflow-rest    | 18301
[8]  | workflow-web     | 18302
[9]  | manm-helper	| 18103
[10] | manm-iam 	| 18102
[11] | manm-portal	| 18101
"
read -p "Please select projenct: " PROJECT_NAME
__selectpj
else
__selectpj
fi
#
if [ "$SERVICE_STATUS" == "" ];then
echo "Operation choices:
[1] | start
[2] | stop
[3] | restart
"
read -p "Please select operation: " SERVICE_STATUS
# elif [ "$SERVICE_STATUS" == "start" -o "$SERVICE_STATUS" == "stop" -o "$SERVICE_STATUS" == "restart" ] || [ "$SERVICE_STATUS" == "1" -o "$SERVICE_STATUS" == "2" -o "$SERVICE_STATUS" == "3" ]; then
# continue
# else
# echo "Please enter right operation: start | stop | restart "
# exit 7
fi
}
#
# do backup
function __dobackup()
{
cp $WARFILE_DIR/$WAR_NAME $BACKUP_DIR/$WAR_NAME-$TIMESTAMP && echo "do backup sucessfully "  ||  (echo "do backup failed " && exit 2)
}
#
# mv new war
function __addwar()
{
cp $UPLOAD_DIR/$WAR_NAME $WARFILE_DIR/$WAR_NAME && echo "copy new war sucessfully "  ||  (echo "do copy failed " && exit 3)
}
#
# cleanup webapps
function __cleanup()
{
rm -rf  $WEBSERVER_DIR/$TOMCAT_DIR/webapps/* && echo "clean up webapps sucessfully "  || (echo "do cleanup failed " && exit 4)
}
#
# start up
function __startup()
{
case $SERVICE_STATUS in
"1"| "start")
bash $WEBSERVER_DIR/$TOMCAT_DIR/bin/catalina.sh start
;;
"2"| "stop")
bash $WEBSERVER_DIR/$TOMCAT_DIR/bin/catalina.sh stop
;;
"3"| "restart")
bash $WEBSERVER_DIR/$TOMCAT_DIR/bin/catalina.sh stop
sleep 3
bash $WEBSERVER_DIR/$TOMCAT_DIR/bin/catalina.sh start
;;
*)
__echohelp
;;
esac
}
#
# ensure projenct dir
function __selectpj()
{
case $PROJECT_NAME in
"1"| "boss-custom" |"18203")
WAR_NAME=boss-manm/boss-custom.war
TOMCAT_DIR=tomcat-boss-manm/tomcat-boss-custom-18203
;;
"2"| "boss-market" |"18204")
WAR_NAME=boss-manm/boss-market.war
TOMCAT_DIR=tomcat-boss-manm/tomcat-boss-market-18204
;;
"3"| "boss-crm" |"18201")
WAR_NAME=boss-manm/boss-crm.war
TOMCAT_DIR=tomcat-boss-manm/tomcat-boss-crm-18201
;;
"4"| "boss-fund" |"18202")
WAR_NAME=boss-manm/boss-fund.war
TOMCAT_DIR=tomcat-boss-manm/tomcat-boss-fund-18202
;;
"5"| "boss-report" |"18205")
WAR_NAME=boss-manm/boss-report.war
TOMCAT_DIR=tomcat-boss-manm/tomcat-boss-report-18205
;;
"6"| "cas-server" |"16666")
WAR_NAME=zeus-cas/zeus-cas-server.war
TOMCAT_DIR=tomcat-cas/tomcat-cas-server-16666
;;
"7"| "workflow-rest" |"18301")
WAR_NAME=workflow/zeus-workflow-rest.war
TOMCAT_DIR=tomcat-workflow/tomcat-workflow-rest-18301
;;
"8"| "workflow-web" |"18302")
WAR_NAME=workflow/zeus-workflow-web.war
TOMCAT_DIR=tomcat-workflow/tomcat-workflow-web-18302
;;
"9"| "manm-helper" |"18103")
WAR_NAME=zeus-manm/zeus-manm-helper.war
TOMCAT_DIR=tomcat-zeus-manm/tomcat-helper-18103
;;
"10"| "manm-iam" |"18102")
WAR_NAME=zeus-manm/zeus-manm-iam.war
TOMCAT_DIR=tomcat-zeus-manm/tomcat-iam-18102
;;
"11"| "manm-portal" |"18101")
WAR_NAME=zeus-manm/zeus-manm-portal.war
TOMCAT_DIR=tomcat-zeus-manm/tomcat-portal-18101
;;
*)
echo "This PROJECT_NAME dont exist！"
__echohelp
;;
esac
}
#
# main()
while true
do
# if [ "$#" == "0" -o "$#" == "1" -o "$#" == "2" ];then
__echohelp
# else
# echo "usage: $0 PROJECT_NAME start | stop | restart"
# exit 8
# fi
#
if [ "$WAR_NAME" !=  "" ] && [ "$TOMCAT_DIR" != "" ];then
echo $WAR_NAME $TOMCAT_DIR
read -p "Please check path and package:[y|n]" CHECK
	if [ "$CHECK" == "y" -o "$CHECK" == "Y" ] && [ "$SERVICE_STATUS" == "1" -o "$SERVICE_STATUS" == "start" ];then
		__dobackup && __addwar && __cleanup && __startup
		exit 5
	elif [ "$CHECK" == "y" -o "$CHECK" == "Y" ] && [ "$SERVICE_STATUS" == "2" -o "$SERVICE_STATUS" == "stop" -o "$SERVICE_STATUS" == "3" -o "$SERVICE_STATUS" == "restart" ];then
		__startup
		exit 6
	else
		continue
	fi
fi
done
