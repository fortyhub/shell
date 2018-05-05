#!/bin/bash
# logroll
# roll over the log files if sizes have reached the MARK
# could also be used for mail boxes ?
# limit size of log
# 4096 K
BLOCK_LIMIT=8

MYDATE=`date +%d%m`
# list of logs to check...yours will be different!
LOGS="/var/spool/audlog /var/spool/network/netlog /etc/dns/named_log"
for LOG_FILE in $LOGS
do
	if [ -f $LOG_FILE ]; then
		#get block size
		F_SIZE=`du -a $LOG_FILE | cut -f1`
	else
		echo "`basename $0` cannot find $LOG_FILE" >&2
		#could exit here,but I want to make sure we hit all
		#logs
		continue
	fi

	if [ "$F_SIZE" -gt "$BLOCK_LIMIT" ]; then
		#copy the log across and append a ddmm date on it
		cp $LOG_FILE $LOG_FILE$MYDATE
		#create / zero the new log
		>$LOG_FILE
		chgrp admin $LOG_FILE$MYDATE
	fi
done
