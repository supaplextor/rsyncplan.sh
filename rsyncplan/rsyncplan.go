package main

import (
	"log"
	"os"
	"os/exec"
	"strings"
)

func main() {
	argsWithoutProg := os.Args[1:]
	args := os.Args

	if len(argsWithoutProg) == 0 {
		log.Fatal("Failure to provide target backup server (ssh+rsync+etc)?")
		os.Exit(1)
	}
}

/*
ops="--rsync-path=/usr/local/sbin/rsyncplan-exechook.sh \
	--timeout=1200 \
	--exclude=/swapfile \
	-iSaXAlx"

me=`hostname`
doRemoteLinks=true

TIMESTAMP_YMDHMS_NS=$(date "+%Y-%m-%d_%H%M%S.%N")
ifs=/
OFS=/backups/${me}/rootfs
RSYNCPLAN_DESINATION_HOST=$1

# rsyncplan -p /home -l home -h rsyncplan-dump
*/

//if ${doRemoteLinks} 
//then
//links=$(ssh "${RSYNCPLAN_DESINATION_HOST}" ls -1d "${OFS}/????-??-??*/" 2>/dev/null |\
	//sort -nr |\
	//head -n 20 |\
	//awk '{print "--link-dest=__OFS__/"$1"/"}' |\
	//sed -e "s#__OFS__##g" | tr -s /
	//)
//fi
//

rsync $ops $links $ifs "${RSYNCPLAN_DESINATION_HOST}":"${OFS}/${TIMESTAMP_YMDHMS_NS}/"

*/