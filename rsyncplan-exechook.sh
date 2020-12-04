#!/bin/bash
# (C) 2020 - supaplextor cloned/exported code to https://github.com/supaplextor/rsyncplan
# (C) 2014 Scott Edwards - https://code.google.com/p/rsyncplan/

tmpd=$(mktemp -d)
echo "$0 $@" >> ${tmpd}/bash-shim-args.$$

function mymkdirnow() {
shift $(($#-1))
OFS=$1

test -d "${OFS}" || mkdir -pv "${OFS}" >&2
}

mymkdirnow "$@"

rsync "$@"

exit $?
