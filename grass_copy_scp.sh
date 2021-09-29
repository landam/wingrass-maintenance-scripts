#!/bin/sh

WWW_DIR=/var/www/wingrass
HOST=landamar@wingrass

SOURCE_DIR=/c/users/landamar/grass_packager/grass78
TARGET_DIR=$WWW_DIR/grass78/x86_64

# wingrass.fsv.cvut.cz
scp $SOURCE_DIR/WinGRASS-* $HOST:$TARGET_DIR/
scp $SOURCE_DIR/grass-*.tar.bz2 $HOST:$TARGET_DIR/osgeo4w/
scp -r $SOURCE_DIR/log-* $HOST:$TARGET_DIR/logs
