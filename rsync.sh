#!/bin/bash
rsync_server=wgg-ops-yum-1
rsync_user=yum
rsync_pwd=/etc/rsyncd.secrets
rsync_module=centos_source
RSYNC_EXCLUDE=source_path=/www/centos_source/
createrepo_rsync_trigger()
{
/usr/bin/inotifywait -mrq --format '%w %f %e' -e delete,create,move,modify ${source_path} |  while read line
do
	/bin/logger $line
	if echo $line | grep ".olddata DELETE,ISDIR" >/dev/null 2>&1 ; then
		/usr/bin/rsync -auvrtzopgP --exclude-from=${RSYNC_EXCLUDE} --delete --progress --bwlimit=200 \
		--password-file=${rsync_pwd} ${source_path} ${rsync_user}@${rsync_server}::${rsync_module} >/dev/null
	fi
done
}

createrepo_rsync_trigger &
