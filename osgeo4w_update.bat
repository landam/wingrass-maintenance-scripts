@echo off

cd C:\Users\landamar\grass_packager

REM
echo Update OSGeo4W installations
REM

call:updateOSGeo4W 
call:updateOSGeo4W _grass7
call:updateOSGeo4W _grass8

exit /b %ERRORLEVEL%

:updateOSGeo4W
	echo ...(%~1)
	osgeo4w-setup -g -k -a x86_64 -q -R C:\OSGeo4W%~1 -s http://download.osgeo.org/osgeo4w/v2
exit /b 0
