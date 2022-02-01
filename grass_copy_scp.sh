#!/bin/sh -e

export PATH=/c/msys64/usr/bin:${PATH}

function copy {
    SOURCE_DIR=${HOME}/grass$1
    # wingrass.fsv.cvut.cz
    HOST=landamar@wingrass

    PLATFORM=""
    if [ ${1:0:1} != "8" ] ; then
	PLATFORM="x86_64"
    fi
    if [ ${#1} == 2 ] ; then
	VERSION=${1:0:1}.${1:1:2}.dev      # daily
	TARGET_DIR=/var/www/wingrass/grass$1/$PLATFORM
	scp $SOURCE_DIR/WinGRASS-* $HOST:$TARGET_DIR/
	ssh $HOST mkdir -p $TARGET_DIR/osgeo4w/
	scp $SOURCE_DIR/grass-*.tar.bz2 $HOST:$TARGET_DIR/osgeo4w/
	scp -r $SOURCE_DIR/log-* $HOST:$TARGET_DIR/logs
    else 
	VERSION=${1:0:1}.${1:1:1}.${1:2:4} # release
	TARGET_DIR=/var/www/wingrass/grass${1:0:1}${1:1:1}/$PLATFORM
    fi
    ssh $HOST mkdir -p $TARGET_DIR/addons/grass-$VERSION/
    scp -r $SOURCE_DIR/addons/*.zip $SOURCE_DIR/addons/*.md5sum $SOURCE_DIR/addons/logs/ $HOST:$TARGET_DIR/addons/grass-$VERSION/
}

function copy_release {
    # release
    HOST=martinl@grass.osgeo.org
    SOURCE_DIR=${HOME}/grass$GVERSION
    GVERSION=${1:0:1}${1:1:1}
    VERSION=${1:0:1}.${1:1:1}.${1:2:4} # release
    PLATFORM=""
    if [ ${1:0:1} != "8" ] ; then
	PLATFORM="x86_64"
    fi
    
    scp $SOURCE_DIR/WinGRASS-* $HOST:
    # scp $SOURCE_DIR/grass-*.tar.bz2 $HOST:/osgeo/download/osgeo4w/v2/$PLATFORM/release/grass/
    ssh $HOST scp WinGRASS-* grass.lxd:wingrass$GVERSION
    ssh $HOST rm WinGRASS-*
    ssh $HOST ssh grass.lxd rm -f wingrass$GVERSION/WinGRASS-${VERSION}RC*
    
    # addons
    HOST=landamar@wingrass
    TARGET_DIR=/var/www/wingrass/grass${1:0:1}${1:1:1}/$PLATFORM

    ssh $HOST rm -rf $TARGET_DIR/addons/grass-${VERSION}RC*
    ssh $HOST mkdir -p $TARGET_DIR/addons/grass-$VERSION/
    scp -r $SOURCE_DIR/addons/*.zip $SOURCE_DIR/addons/*.md5sum $SOURCE_DIR/addons/logs/ $HOST:$TARGET_DIR/addons/grass-$VERSION/
}

if test -z $1 ; then
    copy 78
    copy 786
    copy 80
    copy 800
    copy 81    
else
    copy_release $1
fi

exit 0


