@echo off

cd C:\Users\landa\grass_packager

REM
echo Update OSGeo4W installations
REM

REM 32bit
call:updateOSGeo4W x86 32
call:updateOSGeo4W x86 32_grass7
call:updateOSGeo4W x86 32_grass7_py3

REM 64bit
call:updateOSGeo4W x86_64 64
call:updateOSGeo4W x86_64 64_grass7
call:updateOSGeo4W x86_64 64_grass7_py3

exit /b %ERRORLEVEL%

:updateOSGeo4W
	echo ...(%~1 / %~2)
	osgeo4w-setup -g -k -a %~1 -q -R C:\OSGeo4W%~2 -s http://download.osgeo.org/osgeo4w
exit /b 0
