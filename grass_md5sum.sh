#!/bin/sh
# Create mdb5sum files for GRASS versions
#
# Options:
#  - platform (32 or 64)
#  - src postfix, eg. '70'

export PATH=/c/msys64/usr/bin:/c/msys64/mingw64/bin:/c/osgeo4w/bin:${PATH}

function create_md5sum {
    GRASS_DIR=$1
    
    cd ${HOME}/${GRASS_DIR}
    for file in `ls WinGRASS*.exe`; do
	md5sum $file > ${file}.md5sum
    done
}

if test -z $2 ; then
    # dev packages
    create_md5sum grass78
    # create_md5sum grass80
else
    create_md5sum grass$2
fi

exit 0
