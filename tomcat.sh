#!/bin/bash
# writer:qiulibo
# fun:to start tomcat
# date:2017.7.18

#enter exp and statu
EXP=$1
STATUS=$2
if [ $# -ne 2 ];then
echo "enter args error, pls check!"
exit 1
fi

#export java env
export JAVA_HOME=/usr/local/java
export JRE_HOME=/usr/local/java/jre

#select EXP
case $EXP in
"tomcat1")
export CATALINA_BASE=/data/tomcat1
;;
"tomcat2")
export CATALINA_BASE=/data/tomcat2
;;
*)
echo "Uasge: $1 {tomcat1|tomcat2}"
exit 2
;;
esac
export CATALINA_HOME=/usr/local/tomcat9
# JVM options
#export JVM_OPTIONS="-Xms128m -Xmx1024m -XX:PermSize=128m -XX:MaxPermSize=512m"

case $STATUS in
"start")
nohup /usr/local/tomcat9/bin/catalina.sh start & >/dev/null 2>&1
;;
"stop")
/bin/bash /usr/local/tomcat9/bin/catalina.sh stop
;;
"restart")
/bin/bash /usr/local/tomcat9/bin/catalina.sh stop
sleep 5
nohup /usr/local/tomcat9/bin/catalina.sh start & >/dev/null 2>&1
;;
*)
echo "Uasge: $2 {start|stop|restart}"
exit 3
;;
esac
