#!/bin/bash
set -o errexit  # exit if error
set -o nounset  # exit if variable not initalized
set +h          # disable hashall

source $TOPDIR/config.inc
source $TOPDIR/function.inc
_prgname=${0##*/}   # script name minus the path

_package="perl"
_version="5.26.1"
_sourcedir="${_package}-${_version}"
_log="$LFS_TOP/$LOGDIR/$_prgname.log"
_completed="$LFS_TOP/$LOGDIR/$_prgname.completed"

_red="\\033[1;31m"
_green="\\033[1;32m"
_yellow="\\033[1;33m"
_cyan="\\033[1;36m"
_normal="\\033[0;39m"


printf "${_green}==>${_normal} Building $_package-$_version: "

[ -e $_completed ] && {
    printf "${_yellow}SKIPPING${_normal}\n"
    exit 0
} || printf "\n"

# unpack sources
[ -d $_sourcedir ] && rm -rf $_sourcedir
unpack "${PWD}" "${_package}-${_version}"

# cd to source dir
cd $_sourcedir

# prep
build2 "sed -i \"s@/usr/include@$TOOLS/include@g\" ext/Errno/Errno_pm.PL" $_log
build2 "./configure.gnu \
    --prefix=$TOOLS \
    -Dcc=\"gcc ${BUILD32}\"" $_log

# build
build2 "make $MKFLAGS" $_log

# install
build2 "make install" $_log
build2 "ln -sfv $TOOLS/bin/perl /usr/bin" $_log

# clean up
cd ..
rm -rf $_sourcedir

# make .completed file
touch $_completed

# exit sucessfully
exit 0