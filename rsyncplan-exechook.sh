#!/bin/bash
# (C) 2014-2020 - supaplextor cloned/exported code to https://github.com/supaplextor/rsyncplan
# (C) 2014 Scott Edwards - https://code.google.com/p/rsyncplan/


function outputFileSystem() {
	shift $(($#-1))
	echo "$1"
}
function newestSnapshots() {
	set -x
	pushd $1
	ls -1d ????-??-??*/ 2>/dev/null |\
		sort -nr |\
		head -n 21 |\
		tail -n 20 |\
		sed -e s/^/--link-dest:/g |\
		tr : =
	popd
	set +x
}

TIMESTAMP_YMDHMS=$(date "+%Y-%m-%d_%H%M%S")
OFS=$(outputFileSystem $@)
OFS_TS=$(mktemp -d "${OFS}${TIMESTAMP_YMDHMS}-XXXXXXXX")/
links=$(newestSnapshots ${OFS} )

echo rsync "${links}" "$@" "${OFS_TS}" >&2

rmdir "${OFS_TS}" &>/dev/null
