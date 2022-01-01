#!/bin/sh

export PATH=/c/msys64/usr/bin:${PATH}

function copy {
    SOURCE_DIR=${HOME}/grass$1
    TARGET_DIR=/var/www/wingrass/grass$1/x86_64
    VERSION=${1:0:1}.${1:1:2}.dev
    # wingrass.fsv.cvut.cz
    HOST=landamar@wingrass

    scp $SOURCE_DIR/WinGRASS-* $HOST:$TARGET_DIR/
    scp $SOURCE_DIR/grass-*.tar.bz2 $HOST:$TARGET_DIR/osgeo4w/
    scp -r $SOURCE_DIR/log-* $HOST:$TARGET_DIR/logs
    scp -r $SOURCE_DIR/addons/*.zip $SOURCE_DIR/addons/*.md5sum $SOURCE_DIR/addons/logs/ $HOST:$TARGET_DIR/addons/grass-$VERSION/
}

function copy_release {
    # release
    GVERSION=$1
    HOST=martinl@grass.osgeo.org
    SOURCE_DIR=${HOME}/grass$GVERSION
    # scp $SOURCE_DIR/WinGRASS-* $HOST:
    # scp $SOURCE_DIR/grass-*.tar.bz2 $HOST:/osgeo/download/osgeo4w/v2/x86_64/release/grass/
    # ssh $HOST ./copy_binaries.sh
    
    # addons
    HOST=landamar@wingrass
    VERSION=${GVERSION:0:1}${GVERSION:1:1}
    FVERSION=${GVERSION:0:1}.${GVERSION:1:1}.${GVERSION:2:2}
    TARGET_DIR=/var/www/wingrass/grass$VERSION/x86_64
    # ssh $HOST mkdir $TARGET_DIR/addons/grass-$FVERSION
    # scp -r $SOURCE_DIR/addons/* $HOST:$TARGET_DIR/addons/grass-$FVERSION/
    # TBD: only for final release
    # remove rc
    # ssh $HOST rm -rf $TARGET_DIR/addons/grass-${FVERSION}RC*
    # update latest
    # ssh $HOST ln -sf $TARGET_DIR/addons/grass-${FVERSION} $TARGET_DIR/addons/latest
}

if test -z $1 ; then
    copy 78
    copy 80
else
    copy_release $1
fi

exit 0


