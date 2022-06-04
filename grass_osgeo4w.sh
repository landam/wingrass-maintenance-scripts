#!/bin/sh
# Copy GRASS OSGeo4W package
#
# Options:
#  - pkg postfix, eg. '70'
#  - pkg version number
#  - pkg patch number

PATH_ORIG=`echo $PATH`

export PATH=/c/msys64/usr/bin:/c/msys64/mingw64/bin:/c/osgeo4w/bin:${PATH}

function rsync_package {
    POSTFIX=$1
    VERSION=$2
    PATCH=$3

    dir=${HOME}/grass${POSTFIX}/osgeo4w/package
    curr=`ls -t $dir/ 2>/dev/null | head -n1 | cut -d'-' -f4 | cut -d'.' -f1`
    if [ $? -eq 0 ]; then
	package=$curr
    else
	package=1
    fi

    if test -z $VERSION; then
	# daily builds
	cp $dir/grass*-$package*.tar.bz2 ${HOME}/grass${POSTFIX}
    else
	# release
	cp $dir/grass*-$package*.tar.bz2 ${HOME}/grass${POSTFIX}/grass-${VERSION}-${PATCH}.tar.bz2
    fi

    src_package $POSTFIX $VERSION $PATCH
}

function src_package {
    POSTFIX=$1
    VERSION=$2
    PATCH=$3

    tar cvjf grass-${VERSION}-${PATCH}-src.tar.bz2 -C  ${HOME}/grass${POSTFIX}/osgeo4w package.sh
}

if test -z $1 ; then
    # dev packages
    rsync_package 78
    rsync_package 80
    rsync_package 82
    rsync_package 83
else
    rsync_package $1 $2 $3
fi

exit 0
