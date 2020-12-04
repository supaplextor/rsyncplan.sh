#!/bin/bash
# (C) 2020 - supaplextor cloned/exported code to https://github.com/supaplextor/rsyncplan
# (C) 2014 Scott Edwards - https://code.google.com/p/rsyncplan/

# tmpd=$(mktemp -d)
# echo "$0 $@" >> ${tmpd}/bash-shim-args.$$

function mymkdirnow() {
# target directory is the last param. yank it in this function scope so we don't break it.
# this target script shoehorns rsync into the mix after mkdir -p takes place.
shift $(($#-1))
OFS=$1

test -d "${OFS}" || mkdir -pv "${OFS}" >&2
}

mymkdirnow "$@"

rsync "$@"

exit $?
