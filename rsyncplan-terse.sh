#!/bin/bash
# (C) 2020 - supaplextor cloned/exported code to https://github.com/supaplextor/rsyncplan
# (C) 2014 Scott Edwards - https://code.google.com/p/rsyncplan/
# Latest is always at: git clone https://code.google.com/p/rsyncplan/

# ops="--delete-excluded --timeout=120 --exclude=*.config/google-chrome/Default/* --delete-after -4iSvPaXAplx --bwlimit=1500"

ops="--rsync-path=/usr/local/sbin/rsyncplan-exechook.sh \
	--delete-excluded --timeout=120 \
	--exclude=/swapfile \
	--exclude=*.config/google-chrome/Default/* \
	--delete-after -4iSvPaXAplx"

me=mailserver
me=`hostname`
remotehost=nas
mkdirsuccess=notready

fs=$1
d=$(date "+%Y-%m-%d")
ifs=$fs
ofs=$fs
OFS=/backups/${me}/$ofs
if [ rootfs = $ifs ]
then
		ifs=/
else
		ifs=/$ifs/
fi

links=$(ssh "${remotehost}" ls -1d "${OFS}/????-??-??/" 2>/dev/null |\
	grep -v $d |\
	sort -nr |\
	head -n 20 |\
	awk '{print "--link-dest=__OFS__/"$1"/"}' |\
	sed -e "s#__OFS__##g" | tr -s /
	)
	
rsync $ops $links $ifs "${remotehost}":"${OFS}/${d}/"
