#!/bin/sh
# Compile GRASS versions (update source code from Git repository)
#
# Options:
#  - platform (32 or 64)
#  - src postfix, eg. '_trunk'
#  - pkg postfix, eg. '-daily'

SRC_DIR=usr/src
PACKAGEDIR=mswindows/osgeo4w/package

if test -z "$1"; then
    echo "platform not specified"
    exit 1
fi
PLATFORM=$1
PATH=/c/msys${PLATFORM}/usr/bin:/c/msys${PLATFORM}/mingw${PLATFORM}/bin:/c/osgeo4w${PLATFORM}/bin:${PATH}
if [ "$PLATFORM" == "64" ] ; then
    export PATH=${PATH}:/c/windows/syswow64
else
    export PATH=${PATH}:/c/windows/system32
fi

function rm_package_7 {
    for f in `find $PACKAGEDIR/grass*.tar.bz2 -mtime +7 2>/dev/null`; do
        rm -rfv $f
    done
}

function compile {
    GRASS_DIR=$1
    PACKAGE_POSTFIX=$2

    cd /c/msys${PLATFORM}/$SRC_DIR/$GRASS_DIR
    git pull

    rm -f d*.o # remove obj dumps
    rm_package_7
    curr=`ls -t $PACKAGEDIR/ 2>/dev/null | head -n1 | cut -d'-' -f5 | cut -d'.' -f1`
    if [ $? -eq 0 ]; then
	num=$(($curr+1))
    else
	num=1
    fi
    rev=`git rev-parse --short HEAD`
    package="$rev-$num"
    
    echo "Compiling ${PLATFORM}bit $GRASS_DIR ($package)..."
    rm -f mswindows/osgeo4w/configure-stamp
    PACKAGE_PATCH=$package PACKAGE_POSTFIX=$PACKAGE_POSTFIX OSGEO4W_POSTFIX=$PLATFORM ./mswindows/osgeo4w/package.sh
}

if test -z $2 ; then
    # dev packages
    compile grass74 -daily
    compile grass76 -daily
    compile grass77 -daily
else
    compile grass$2 $3 
fi

exit 0
