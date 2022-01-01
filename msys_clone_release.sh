#!/bin/sh -e

PATH=/usr/bin:/mingw64/bin:/c/osgeo4w/bin:/c/windows/syswow64:${PATH}

if test -z $1; then
    echo "specify release, eg. 7.8.5RC1"
    exit 1
fi
release=$1
release_dir=`echo $release | sed 's/\.//g'`
cd /usr/src
(cd grass78; git pull)
rm -rf *RC* # remove all RC (clean-up)
git clone grass78 grass$release_dir
cd grass$release_dir
git checkout $release
git pull

exit 0
