#!/bin/sh

export PATH=/c/msys64/usr/bin:${PATH}

REV=$1

sed -i "s/!define BINARY_REVISION \"1\"/!define BINARY_REVISION \"$REV\"/g" GRASS-Installer.nsi

exit 0
