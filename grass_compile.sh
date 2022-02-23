#!/bin/sh
# Compile GRASS versions (update source code from Git repository)
#
# Options:
#  - src postfix, eg. '_trunk'
#  - pkg postfix, eg. '-daily'

SRC_DIR=/usr/src
PACKAGEDIR=mswindows/osgeo4w/package

PATH=/usr/bin:/mingw64/bin:/c/osgeo4w/bin:/c/windows/syswow64:${PATH}

LC_ALL=C

function rm_package_7 {
    for f in `find $PACKAGEDIR/grass*.tar.bz2 -mtime +7 2>/dev/null`; do
        rm -rfv $f
    done
}

function compile {
    GRASS_DIR=$1
    PACKAGE_POSTFIX=$2

    cd $SRC_DIR/$GRASS_DIR
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
    
    echo "Compiling $GRASS_DIR ($package)..."
    rm -f mswindows/osgeo4w/configure-stamp
    PACKAGE_PATCH=$package PACKAGE_POSTFIX=$PACKAGE_POSTFIX \
    OSGEO4W_ROOT_MSYS=/c/osgeo4w \
    VCPATH="C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Tools\MSVC\14.29.30133\bin\Hostx86\x64" \
    ./mswindows/osgeo4w/package.sh
}

if test -z $1 ; then
    # dev packages
    compile grass78 -daily
    compile grass80 -daily
    compile grass81 -daily    
else
    compile grass$1 
fi

exit 0
