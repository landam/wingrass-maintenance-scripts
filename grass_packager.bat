@echo off

cd C:\Users\landa\grass_packager

REM
echo Clean-up...
REM
call :cleanUp 32
call :cleanUp 64

REM
echo Compiling GRASS GIS...
REM
C:\msys32\usr\bin\bash.exe .\grass_compile.sh 32
C:\msys64\usr\bin\bash.exe .\grass_compile.sh 64

REM
echo Clean-up for packaging...
REM
call:cleanUpPkg x86    32
call:cleanUpPkg x86_64 64

REM
echo Preparing packages...
REM
call:preparePkg x86    32
call:preparePkg x86_64 64

REM
echo Finding latest package and update info...
REM
C:\msys32\usr\bin\bash.exe .\grass_osgeo4w.sh  32
C:\msys64\usr\bin\bash.exe .\grass_osgeo4w.sh  64
C:\msys32\usr\bin\bash.exe .\grass_rev_info.sh 32
C:\msys64\usr\bin\bash.exe .\grass_rev_info.sh 64

REM
echo Creating standalone installer...
REM
call:createPkg x86
call:createPkg x86_64

REM
REM Create md5sum files
REM
C:\msys32\usr\bin\bash.exe .\grass_md5sum.sh 32
C:\msys64\usr\bin\bash.exe .\grass_md5sum.sh 64

REM
echo Building addons...
REM
C:\msys32\usr\bin\bash.exe .\grass_addons.sh 32
C:\msys64\usr\bin\bash.exe .\grass_addons.sh 64

REM
echo Publishing packages...
REM
C:\msys32\usr\bin\bash.exe .\grass_copy_wwwroot.sh 32
C:\msys64\usr\bin\bash.exe .\grass_copy_wwwroot.sh 64

exit /b %ERRORLEVEL%

:cleanUp
	echo ...(%~1)
        REM for /d %%G in ("C:\OSGeo4W%~1\apps\grass\grass7*") do rmdir /S/Q "%%G"
exit /b 0

:cleanUpPkg
	echo ...(%~1)
	REM if not exist "grass76" mkdir grass76
	REM if exist .\grass76\%~1 rmdir /S/Q .\grass76\%~1
	REM xcopy C:\msys%~2\usr\src\grass76\mswindows\* .\grass76\%~1 /S/V/I > NUL
	if not exist "grass78" mkdir grass78
	if exist .\grass78\%~1 rmdir /S/Q .\grass78\%~1
	xcopy C:\msys%~2\usr\src\grass78\mswindows\*     .\grass78\%~1 /S/V/I > NUL
	if not exist "grass80" mkdir grass80
	if exist .\grass80\%~1 rmdir /S/Q .\grass80\%~1
	xcopy C:\msys%~2\usr\src\grass80\mswindows\*     .\grass80\%~1 /S/V/I > NUL
exit /b 0

:preparePkg
	echo ...(%~1)
	REM cd .\grass76\%~1
	REM call .\GRASS-Packager.bat %~2 > .\GRASS-Packager.log
	REM cd ..\..
	cd .\grass78\%~1
	call .\GRASS-Packager.bat %~2 > .\GRASS-Packager.log
	cd ..\..
	cd .\grass80\%~1
	call .\GRASS-Packager.bat %~2 > .\GRASS-Packager.log
	cd ..\..
exit /b 0

:createPkg
	echo ...(%~1)
        REM C:\DevTools\makensis.exe .\grass76\%~1\GRASS-Installer.nsi > .\grass76\%~1\GRASS-Installer.log
        C:\DevTools\makensis.exe .\grass78\%~1\GRASS-Installer.nsi > .\grass78\%~1\GRASS-Installer.log
        C:\DevTools\makensis.exe .\grass80\%~1\GRASS-Installer.nsi > .\grass80\%~1\GRASS-Installer.log
exit /b 0
