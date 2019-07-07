@echo off

cd C:\Users\landa\grass_packager

REM
echo Clean-up...
REM
REM call :cleanUp 32
call :cleanUp 64

REM
echo Compiling GRASS GIS...
REM
REM C:\msys32\usr\bin\bash.exe .\grass_compile.sh 32 77 -daily
C:\msys64\usr\bin\bash.exe .\grass_compile.sh 64 77 -daily


REM
echo Clean-up for packaging...
REM
REM call:cleanUpPkg x86    32
REM call:cleanUpPkg x86_64 64

REM
echo Preparing packages...
REM
REM call:preparePkg x86    32
REM call:preparePkg x86_64 64

REM
echo Finding latest package and update info...
REM
REM C:\msys32\usr\bin\bash.exe .\grass_osgeo4w.sh  32
C:\msys64\usr\bin\bash.exe .\grass_osgeo4w.sh  64 77
REM C:\msys32\usr\bin\bash.exe .\grass_rev_info.sh 32 73
C:\msys64\usr\bin\bash.exe .\grass_rev_info.sh 64 77

pause 
REM
echo Creating standalone installer...
REM
REM call:createPkg x86
REM call:createPkg x86_64

REM
REM Create md5sum files
REM
REM C:\msys32\usr\bin\bash.exe .\grass_md5sum.sh 32 73
C:\msys64\usr\bin\bash.exe .\grass_md5sum.sh 64 77

REM
echo Building addons...
REM
REM C:\msys32\usr\bin\bash.exe .\grass_addons.sh 32
C:\msys64\usr\bin\bash.exe .\grass_addons.sh 64 77

pause 

REM
echo Publishing packages...
REM
REM C:\msys32\usr\bin\bash.exe .\grass_copy_wwwroot.sh 32
REM C:\msys64\usr\bin\bash.exe .\grass_copy_wwwroot.sh 64

exit /b %ERRORLEVEL%

:cleanUp
	echo ...(%~1)
        for /d %%G in ("C:\OSGeo4W%~1\apps\grass\grass-7*svn") do rmdir /S/Q "%%G"
exit /b 0

:cleanUpPkg
	echo ...(%~1)
	if not exist "grass77" mkdir grass77
	if exist .\grass77\%~1 rmdir /S/Q .\grass77\%~1
	xcopy C:\msys%~2\usr\src\grass77\mswindows\*     .\grass77\%~1 /S/V/I > NUL
exit /b 0

:preparePkg
	echo ...(%~1)
	cd .\grass77\%~1
	call .\GRASS-Packager.bat %~2 > .\GRASS-Packager.log
	cd ..\..
exit /b 0

:createPkg
	echo ...(%~1)
        C:\DevTools\makensis.exe .\grass77\%~1\GRASS-Installer.nsi > .\grass77\%~1\GRASS-Installer.log
exit /b 0
