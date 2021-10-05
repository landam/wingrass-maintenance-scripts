@echo off

REM
REM TODO: merge with grass_packager.bat
REM

set HOME=C:\Users\landamar\grass_packager
cd %HOME%

set MAJOR=7
set MINOR=8
set PATCH=6RC3
set REV=1

set GVERSION=%MAJOR%%MINOR%%PATCH%

REM
echo Clean-up...
REM
REM call :cleanUp

REM
echo Cloning release...
REM
REM C:\msys64\usr\bin\bash.exe .\msys_clone_release.sh %MAJOR%.%MINOR%.%PATCH%

REM
echo Compiling GRASS GIS...
REM
REM C:\msys64\usr\bin\bash.exe .\grass_compile.sh %GVERSION%

REM
echo Clean-up for packaging...
REM
REM call:cleanUpPkg

REM
echo Preparing packages...
REM
REM call:preparePkg

REM
echo Finding latest package and update info...
REM
REM C:\msys64\usr\bin\bash.exe .\grass_osgeo4w.sh  %GVERSION% %MAJOR%.%MINOR%.%PATCH% %REV%
REM C:\msys64\usr\bin\bash.exe .\grass_rev_info.sh %GVERSION% %REV%

REM
echo Creating standalone installer...
REM
REM call:createPkg

REM
REM Create md5sum files
REM
REM C:\msys64\usr\bin\bash.exe .\grass_md5sum.sh %GVERSION%

REM
echo Building addons...
REM
C:\msys64\usr\bin\bash.exe .\grass_addons.sh %GVERSION%

exit /b %ERRORLEVEL%

:cleanUp
        if exist "C:\OSGeo4W\apps\grass\grass-%MAJOR%.%MINOR%.%PATCH%" rmdir /S/Q "C:\OSGeo4W%~1\apps\grass\grass-%MAJOR%.%MINOR%.%PATCH%"
exit /b 0

:cleanUpPkg
	if exist .\grass%GVERSION% rmdir /S/Q .\grass%GVERSION%
	xcopy C:\msys64\usr\src\grass%GVERSION%\mswindows\* .\grass%GVERSION% /S/V/I > NUL
exit /b 0

:preparePkg
	cd .\grass%GVERSION%
	call .\GRASS-Packager.bat > .\GRASS-Packager.log
	cd ..
exit /b 0

:createPkg
	C:\DevTools\makensis.exe .\grass%GVERSION%\GRASS-Installer.nsi > .\grass%GVERSION%\GRASS-Installer.log
exit /b 0
