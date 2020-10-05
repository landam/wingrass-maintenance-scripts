#!/bin/sh
# Compile GRASS GIS Addons
#
# Options:
#  - platform (32 or 64)
#  - src postfix, eg. '_trunk'

if test -z "$1"; then
    echo "platform not specified"
    exit 1
fi
PLATFORM=$1
# export PATH=/c/osgeo4w${PLATFORM}/bin:/c/msys${PLATFORM}/usr/bin:/c/msys${PLATFORM}/mingw${PLATFORM}/bin:${PATH}
export PATH=/c/msys${PLATFORM}/usr/bin:${PATH}
# export PYTHONPATH=
export LANGUAGE=C
export OSGEO4W_ROOT_MSYS="/c/OSGeo4W${PLATFORM}"

SRC_PATH=/c/msys${PLATFORM}/usr/src/grass-addons
GISBASE_PATH=/c/msys${PLATFORM}/usr/src
ADDON_PATH=/c/Users/landa/grass_packager
if [ "$PLATFORM" = "32" ] ; then
    PLATFORM_DIR=x86
else
    PLATFORM_DIR=x86_64
fi

cd $SRC_PATH
git pull

fetchenv() {
    local IFS
    IFS=
    batch=$1
    shift
    srcenv=$(mktemp /tmp/srcenv.XXXXXXXXXX)
    dstenv=$(mktemp /tmp/dstenv.XXXXXXXXXX)
    diffenv=$(mktemp /tmp/diffenv.XXXXXXXXXX)
    args="$@"
    cmd.exe //c set >$srcenv
    cmd.exe //c "call `cygpath -w $batch` $args \>nul 2\>nul \& set" >$dstenv
    diff -u $srcenv $dstenv | sed -f ${SRC_GRASS}/mswindows/osgeo4w/envdiff.sed >$diffenv
    . $diffenv
    PATH=$PATH:/usr/bin:/mingw${MINGW_POSTFIX}/bin/:$PWD/mswindows/osgeo4w/lib:$PWD/mswindows/osgeo4w:/c/windows32/system32:/c/windows:/c/windows32/system32:/c/windows
    rm -f $srcenv $dstenv $diffenv
}

function compile {
    SRC_ADDONS=$1
    SRC_GRASS=$2
    DST_DIR=$3

    fetchenv $OSGEO4W_ROOT_MSYS/bin/o4w_env.bat
    export PATH=${PATH}:/c/msys${PLATFORM}/usr/bin:/c/msys${PLATFORM}/mingw${PLATFORM}/bin
    grass_version=`echo $SRC_GRASS | cut -d '/' -f6 | sed 's/grass//g'`
    if [ ${grass_version:1:1} -ge 8 ]; then
	# alias python=python3
	# py_ver=37
	fetchenv $OSGEO4W_ROOT_MSYS/bin/py3_env.bat
    # else
    # 	py_ver=27
    fi

    # export PYTHONHOME=/c/OSGeo4W${PLATFORM}/apps/Python${py_ver}
    # export PATH=${PYTHONHOME}:${PYTHONHOME}/Scripts:${PATH}

    rm -rf $DST_DIR
    $SRC_PATH/tools/addons/compile.sh $SRC_ADDONS $SRC_GRASS $DST_DIR 1
    cd $DST_DIR
    for d in `ls -d */`; do
	mod=${d%%/}
	if [ $mod == "logs" ] ; then
	    continue
	fi
	cd $mod
	echo $mod
	for f in `ls bin/*.bat 2> /dev/null` ; do
	    echo $f
	    if [ `echo $1 | sed -e 's/\(^.*\)\(.$\)/\2/'` = "6" ] ; then
		replace_gisbase="GRASS_ADDON_PATH"
	    else
		replace_gisbase="GRASS_ADDON_BASE"
	    fi
	    sed "s/GISBASE/$replace_gisbase/" $f > tmp
	    mv tmp $f
	done
	zip -r $mod.zip *
	mv $mod.zip ..
	cd ..
	md5sum $mod.zip > ${mod}.md5sum
    done
}

if test -z $2 ; then
    # compile ${SVN_PATH}/grass6 ${GISBASE_PATH}/grass644        ${ADDON_PATH}/grass644/addons
    # compile ${SRC_PATH}/grass7 ${GISBASE_PATH}/grass761        ${ADDON_PATH}/grass761/${PLATFORM_DIR}/addons    
    compile ${SRC_PATH}/grass7 ${GISBASE_PATH}/grass780    ${ADDON_PATH}/grass780/${PLATFORM_DIR}/addons
    compile ${SRC_PATH}/grass7 ${GISBASE_PATH}/grass781    ${ADDON_PATH}/grass781/${PLATFORM_DIR}/addons
    compile ${SRC_PATH}/grass7 ${GISBASE_PATH}/grass782    ${ADDON_PATH}/grass782/${PLATFORM_DIR}/addons
    compile ${SRC_PATH}/grass7 ${GISBASE_PATH}/grass783    ${ADDON_PATH}/grass783/${PLATFORM_DIR}/addons
    compile ${SRC_PATH}/grass7 ${GISBASE_PATH}/grass784    ${ADDON_PATH}/grass784/${PLATFORM_DIR}/addons
    # compile ${SRC_PATH}/grass7 ${GISBASE_PATH}/grass76  ${ADDON_PATH}/grass76/${PLATFORM_DIR}/addons
    compile ${SRC_PATH}/grass7 ${GISBASE_PATH}/grass78     ${ADDON_PATH}/grass78/${PLATFORM_DIR}/addons
    compile ${SRC_PATH}/grass7 ${GISBASE_PATH}/grass79     ${ADDON_PATH}/grass79/${PLATFORM_DIR}/addons
else
    compile ${SRC_PATH}/grass7 ${GISBASE_PATH}/grass$2  ${ADDON_PATH}/grass$2/${PLATFORM_DIR}/addons
fi

exit 0
