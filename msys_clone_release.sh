#!/bin/sh -e

PLATFORM=$1
PATH=/usr/bin:/mingw${PLATFORM}/bin:/c/osgeo4w${PLATFORM}/bin:${PATH}
if [ "$PLATFORM" == "64" ] ; then
    export PATH=${PATH}:/c/windows/syswow64
else
    export PATH=${PATH}:/c/windows/system32
fi

if test -z $2; then
    echo "specify release, eg. 7.8.5RC1"
    exit 1
fi
release=$2
release_dir=`echo $release | sed 's/\.//g'`
cd /usr/src
(cd grass78; git pull)
rm -rf *RC* # remove all RC (clean-up)
git clone grass78 grass$release_dir
cd grass$release_dir
git checkout $release
git pull

exit 0
