#!/bin/bash
# (C) 2014-2020 - supaplextor cloned/exported code to https://github.com/supaplextor/rsyncplan
# (C) 2014 Scott Edwards - https://code.google.com/p/rsyncplan/

function outputFileSystem() {
	shift $(($#-1))
	echo "$1"
}
function newestSnapshots() {
	pushd $1 &> /dev/null
	ls -1d ????-??-??*/ 2>/dev/null |\
		sort -nr |\
		head -n 21 |\
		tail -n 20 |\
		awk '{print "--link-dest=../"$1}' |\
		tr "\n" " "
	popd &> /dev/null
}

TIMESTAMP_YMDHMS=$(date "+%Y-%m-%d_%H%M%S")
OFS=$(outputFileSystem $@)
OFS_TS=$(mktemp -d "${OFS}${TIMESTAMP_YMDHMS}-XXXXXXXX")
if [ x = x"${OFS_TS}" ] 
then
	echo Target mkdir did not work, bailing now >&2
	exit 50
fi
newARGS=$(echo -- $@ | sed -e s/--link-dest.*//)

echo rsync $(newestSnapshots ${OFS}) "${newARGS}" . "${OFS_TS}/"

rmdir "${OFS_TS}" &>/dev/null
