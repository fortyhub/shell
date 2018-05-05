#!/bin/echo Waring: this library should be sourced!
ostype(){
	osname=`uname -s`
	OSTYPE=UNKNOWN
	case $osname in
	"FreeBSD") OSTYPE="FREEBSD"
	;;
	"SunOS") OSTYPE="SOLARIS"
	;;
	"Linux") OSTYPE="LINUX"
	;;
	esac
	return 0
}
