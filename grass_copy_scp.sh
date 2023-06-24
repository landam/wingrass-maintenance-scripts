#!/bin/bash

export PATH=/c/msys64/usr/bin:${PATH}

function copy {
    echo "Processing $1..."
    SOURCE_DIR=${HOME}/grass$1
    # wingrass.fsv.cvut.cz
    HOST=landamar@wingrass

    PLATFORM=""
    if [ ${1:0:1} != "8" ] ; then
	PLATFORM="x86_64"
    fi
    VERSION=`cat $HOME/grass$1/GRASS-${1:0:1}${1:1:1}-Package/etc/VERSIONNUMBER | cut -d' ' -f1`
    if [ ${#1} == 2 ] ; then
     	TARGET_DIR=/var/www/wingrass/grass$1/$PLATFORM
     	# remove older installers that 30days
     	ssh $HOST "find $TARGET_DIR/WinGRASS-* -mtime +30 -exec rm {} \;" < /dev/null # required otherwise only first line from CSV is processed
     	scp $SOURCE_DIR/WinGRASS-* $HOST:$TARGET_DIR/
	ssh $HOST mkdir -p $TARGET_DIR/osgeo4w/ < /dev/null 
	ssh $HOST "find $TARGET_DIR/osgeo4w/grass-*.tar.bz2 -mtime +30 -exec rm {} \;" < /dev/null 
	scp $SOURCE_DIR/grass-*.tar.bz2 $HOST:$TARGET_DIR/osgeo4w/
	ssh $HOST "find $TARGET_DIR/logs/log-* -mtime +30 -exec rm -r {} \;" < /dev/null 
	scp -r $SOURCE_DIR/log-* $HOST:$TARGET_DIR/logs
    else 
     	TARGET_DIR=/var/www/wingrass/grass${1:0:1}${1:1:1}/$PLATFORM
    fi
    ssh $HOST mkdir -p $TARGET_DIR/addons/grass-$VERSION/ < /dev/null 
    scp -r $SOURCE_DIR/addons/*.zip $SOURCE_DIR/addons/*.md5sum $SOURCE_DIR/addons/logs/ $HOST:$TARGET_DIR/addons/grass-$VERSION/
}

function copy_release {
    # release
    HOST=martinl@grass.osgeo.org
    SOURCE_DIR=${HOME}/grass$1
    GVERSION=${1:0:1}${1:1:1}
    VERSION=${1:0:1}.${1:1:1}.${1:2:4} # release
    PLATFORM=""
    
    if [ ${1:0:1} == "7" ] ; then
	PLATFORM=x86_64
	TARGET_PATH=$TARGET_PATH/$PLATFORM
    fi

    TARGET_DIR=/var/www/code_and_data/grass$GVERSION/binary/mswindows/native/$PLATFORM
    scp $SOURCE_DIR/WinGRASS-* $HOST:
    # scp $SOURCE_DIR/grass-*.tar.bz2 $HOST:/osgeo/download/osgeo4w/v2/$PLATFORM/release/grass/
    # ssh $HOST ssh grass.lxd mkdir -p $TARGET_DIR
    ssh $HOST scp WinGRASS-* grass.lxd:$TARGET_DIR < /dev/null 
    ssh $HOST rm WinGRASS-* < /dev/null 
    if [[ "$VERSION" != *"RC"* ]]; then
	ssh $HOST ssh grass.lxd rm -f /var/www/code_and_data/grass$GVERSION/binary/mswindows/native/WinGRASS-${VERSION}RC* < /dev/null 
    fi
    # addons
    HOST=landamar@wingrass
    TARGET_DIR=/var/www/wingrass/grass${1:0:1}${1:1:1}/$PLATFORM
    ssh $HOST mkdir -p $TARGET_DIR/addons/grass-$VERSION/ < /dev/null 
    scp -r $SOURCE_DIR/addons/*.zip $SOURCE_DIR/addons/*.md5sum $SOURCE_DIR/addons/logs/ $HOST:$TARGET_DIR/addons/grass-$VERSION/
    if [[ "$VERSION" != *"RC"* ]]; then
	ssh $HOST rm -rf $TARGET_DIR/addons/grass-${VERSION}RC < /dev/null
    fi    
}

if test -z $1 ; then
    while read release; do
        copy $release
    done < releases.csv
else
    copy_release $1
fi

exit 0
