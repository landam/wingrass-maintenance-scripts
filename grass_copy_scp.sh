#!/bin/sh

# wingrass.fsv.cvut.cz
HOST=landamar@wingrass
# SOURCE_DIR=/c/users/landamar/grass_packager/grass78
TARGET_DIR=/var/www/wingrass/grass78/x86_64
# scp $SOURCE_DIR/WinGRASS-* $HOST:$TARGET_DIR/
# scp $SOURCE_DIR/grass-*.tar.bz2 $HOST:$TARGET_DIR/osgeo4w/
# scp -r $SOURCE_DIR/log-* $HOST:$TARGET_DIR/logs

# release
# HOST=martinl@grass.osgeo.org
SOURCE_DIR=/c/users/landamar/grass_packager/grass786RC3
# scp $SOURCE_DIR/WinGRASS-* $HOST:
# scp $SOURCE_DIR/grass-*.tar.bz2 $HOST:/osgeo/download/osgeo4w/v2/x86_64/release/grass/

# addons
# ssh $HOST mkdir $TARGET_DIR/addons/grass786RC3
scp -r $SOURCE_DIR/addons/* $HOST:$TARGET_DIR/addons/grass7.8.6RC3/

