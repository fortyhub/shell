#!/bin/bash
#
#读取配置文件，当前目录下setting.ini 文件。格式需要满足ini


source /etc/profile

PROJECTNAME=$1
SERVICESTATUS=$2
PID_DIR=/var/run/service
OPTS512="-Xms512m -Xmx512m -XX:PermSize=128m -XX:MaxPermSize=256m -Xmn256m -XX:CMSInitiatingOccupancyFraction=80"
#第二种内存分配，opt=0则512，opt=1则2048
OPTS2048=" -Xms2048m -Xmx2048m -XX:PermSize=512m -XX:MaxPermSize=1024m -Xmn1024m -XX:CMSInitiatingOccupancyFraction=80"
#第三种内存分配，opt=2则为256M启动
OPTS256=" -Xms128m -Xmx256m -XX:PermSize=128m -XX:MaxPermSize=256m -Xmn128m -XX:CMSInitiatingOccupancyFraction=80"
JAVA="/usr/share/jdk1.8.0_121/jre/bin/java"
LOGWAIT=20
SSHKEY=/scripts/service/id_rsa
# 读取配置方法
function __readINI() {
 INIFILE=/Users/qiulibo/shell/service/setting.ini; SECTION=$1; ITEM=$2
 _readIni=`awk -F '=' '/\['$SECTION'\]/{a=1}a==1&&$1~/'$ITEM'/{print $2;exit}' $INIFILE`
echo ${_readIni}
}

# 帮助信息
function __help(){
echo "Usage: $0 [SERVICENAME|ALL] [start|stop|restart]

SERVICENAME list:

`grep  "\[.*\]" /Users/qiulibo/shell/service/setting.ini|tr -d "\[\]"`
"
}

# 读取相应项目配置
function getInfo(){
SERVICE_DIR=`__readINI $PROJECTNAME  dir`
SERVICE_NAME=`__readINI $PROJECTNAME  name`
JAR_NAME=`cd $SERVICE_DIR && ls $SERVICE_NAME*.jar 2>/dev/null`
PID=$SERVICE_NAME\.pid
BKSERVER=`__readINI $PROJECTNAME  backserver`
eval OPTS=\$`__readINI $PROJECTNAME  opt`
}

# 启动方法
function __start(){
cd $SERVICE_DIR
nohup $JAVA  $OPTS -jar $JAR_NAME > nohup.out  2>&1 &
echo $! > $PID_DIR/$PID
echo "----------------- 我是分割线---------------------

启动完成

----------------- 我是分割线---------------------

打印日志中.....

----------------- 我是分割线---------------------

"
sleep $LOGWAIT && tail -200 nohup.out

echo "----------------- 我是分割线---------------------

打印完毕...

----------------- 我是分割线---------------------"
}

# 判断进程
function __process(){
[ -x /proc/`cat $PID_DIR/$PID` ] && echo "existed"
}

# 关闭方法，强杀
function __stop(){
kill `cat $PID_DIR/$PID`  >/dev/null 2>&1 && rm -f $PID_DIR/$PID
sleep 3
P_ID=`ps -ef | grep  "$SERVICE_NAME" | grep -v "grep\|$0" |  awk '{print $2}'`
if [ "$P_ID" == "" ]; then
echo "----------------- 我是分割线---------------------

正常关闭
"
else
echo "----------------- 我是分割线---------------------

正常关闭失败:$P_ID

----------------- 我是分割线---------------------

强行杀除....

----------------- 我是分割线---------------------"
kill -9 $P_ID
fi
}

# 双实例
function __askbkserver(){
read -p "该项目有两台服务器需要启动，你想启动的是
[1] | boss@localhost
[2] | boss@10.172.202.184
" REALSERVER
}

# local()
function __localact(){
[ -z "$SERVICE_DIR" ] &&  __help && exit 3
case "$SERVICESTATUS" in
start)
__start
;;
stop)
__stop
;;
restart)
__stop
sleep 3
__start
;;
*)
__help
exit 5
;;
esac
}

#back
function __backact(){
case $REALSERVER in
"1"|"boos@localhost")
__localact
;;
"2"|"boss@10.172.202.184")
ssh -i $SSHKEY boss@10.172.202.184 "/scripts/service/startService.sh $PROJECTNAME $SERVICESTATUS"
;;
*)
echo "wrong choice , exiting....."
exit 8
;;
esac
}

# main
if [ $PROJECTNAME == "ALL" ] || [ $PROJECTNAME == "all" ];then
	for PROJECTNAME in `grep  "\[.*\]" /Users/qiulibo/shell/service/setting.ini|tr -d "\[\]"`:
	do
		echo $PROJECTNAME
		echo "getInfo"
		BKSERVER=0
		echo "[ x$BKSERVER == x1 ] && __askbkserver && __backact || __localact"
	done
else
	echo "getInfo"
	echo "[ x$BKSERVER == x1 ] && __askbkserver && __backact || __localact"
fi

