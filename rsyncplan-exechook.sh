#!/bin/bash
# (C) 2014-2020 - supaplextor cloned/exported code to https://github.com/supaplextor/rsyncplan
# (C) 2014 Scott Edwards - https://code.google.com/p/rsyncplan/

# tmpd=$(mktemp -d)
# echo "$0 $@" >> ${tmpd}/bash-shim-args.$$

shift $(($#-1))
OFS=$1

TIMESTAMP_YMDHMS=$(date "+%Y-%m-%d_%H%M%S")

links=$(ls -1d "${OFS}/????-??-??*/" 2>/dev/null |\
	sort -nr |\
	head -n 20 |\
	awk '{print "--link-dest=__OFS__/"$1"/"}' |\
	sed -e "s#__OFS__##g" | tr -s /
)

OFS_TS=$(mktemp -d "${OFS}/${TIMESTAMP_YMDHMS}-XXXXXXXX")
test -d "${OFS_TS}" ||  mkdir -pv "${OFS_TS}" >&2

echo rsync "${links}" "$@" "${OFS_TS}"

rmdir "${OFS_TS}" &>/dev/null
