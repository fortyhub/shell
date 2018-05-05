#!/bin/bash
#pingall form /etc/hosts

#greb /etc/hosts and ping each address
cat /etc/hosts|grep -v "^#" |while read LINE
do
	ADDR=`awk '{print $1}'`
	for MACHINE in $ADDR
	do
		ping -s -c 1 $MACHINE
	done
done
