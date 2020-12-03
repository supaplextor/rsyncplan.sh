#!/bin/bash
# (C) 2020 - supaplextor cloned/exported code to https://github.com/supaplextor/rsyncplan
# (C) 2014 Scott Edwards - https://code.google.com/p/rsyncplan/
# Latest is always at: git clone https://code.google.com/p/rsyncplan/

ops="--delete-excluded --timeout=120 --exclude=*.config/google-chrome/Default/* --delete-after -4iSvPaXAplx --bwlimit=1500"
ops="--delete-excluded --timeout=120 --exclude=*.config/google-chrome/Default/* --delete-after -4iSvPaXAplx"
me=mailserver
me=`hostname`
remotehost=nas

go() {
	fs=$1
	ifs=$fs
	ofs=$fs
	OFS=/backups/"${remotehost}"/${me}/$ofs
	if [ rootfs = $ifs ]
	then
			ifs=/
	else
			ifs=/$ifs/
	fi
	d=$(date "+%Y-%m-%d")
	
	echo Checking ${remotehost} for "${OFS}" presence. Login 1 of 2.
	links=`(ssh -n "${remotehost}" ls -1 $OFS ; echo sshec=$? >&2 ) |\
		tr " " "\n" |\
		grep -v $d |\
		sort -nr |\
		head -n 20 |\
		awk '{print "--link-dest=__OFS__/"$1"/"}' |\
		sed -e "s#__OFS__#$OFS#g" |\
		tr -s /`
	
	echo rsync $ops $links $ifs "${remotehost}":/media/"${remotehost}"/${me}/$ofs/$d/
}

while read fs
do
	echo BEGIN fs=$fs
	go $fs
	echo END $fs ec=$?
done < test-fs
echo DONE.
