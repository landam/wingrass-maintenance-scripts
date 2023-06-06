#!/bin/sh
# Update Git version info
#
# Options:
#  - src postfix, eg. '_trunk'
#  - pkg patch number

SRC=usr/src
PACKAGEDIR=mswindows/osgeo4w/package

export PATH=/c/msys64/usr/bin:/c/msys64/mingw64/bin:/c/osgeo4w/bin:${PATH}

function update {
    GRASS_DIR=grass${1}
    PATCH_NUM=$2

    SRC_PATH=/c/msys64/$SRC/${GRASS_DIR}
    DEST_PATH=${HOME}/${GRASS_DIR}
    
    cd $SRC_PATH

    REV=`git rev-parse --short HEAD`
    if test -z $PATCH_NUM ; then
	NUM=`ls -t $PACKAGEDIR/ 2>/dev/null | head -n1 | cut -d'-' -f5 | cut -d'.' -f1`
	if [ "x$NUM" = "x" ]; then
	    NUM=1
	fi
    else
	NUM=$PATCH_NUM
    fi
    
    exec 3<include/VERSION 
    read MAJOR <&3 
    read MINOR <&3 
    read PATCH <&3 
    VERSION=$MAJOR.$MINOR.$PATCH
    
    if [[ "$PATCH" == *dev* ]] ; then
	TYPE="Devel"
    else
	TYPE="Release"
    fi
    sed -e "s/BINARY_REVISION \"1\"/BINARY_REVISION \"$NUM\"/g" \
	-e "s/INSTALLER_TYPE \"Devel\"/INSTALLER_TYPE \"$TYPE\"/g" \
	$DEST_PATH/GRASS-Installer.nsi > tmp
    mv tmp $DEST_PATH/GRASS-Installer.nsi
    cp error.log $DEST_PATH

    create_log $MAJOR$MINOR $REV $NUM
}

function create_log {
    VERSION=$1
    REV=$2
    PATCH=$3
    
    cd ${HOME}/grass${VERSION}
    LOG_DIR=log-r$2-$3
    
    mkdir -p $LOG_DIR
    cp osgeo4w/package.log $LOG_DIR/
    cp error.log $LOG_DIR/
}

if test -z $1 ; then
    while read version; do
        update $version
    done < dev_packages.csv
else
    update $1 
fi

exit 0
