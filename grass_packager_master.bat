@echo off

set HOME=C:\Users\landamar\grass_packager
cd %HOME%

REM
echo Clean-up...
REM
REM call :cleanUp

REM
echo Compiling GRASS GIS...
REM
C:\msys64\usr\bin\bash.exe .\grass_compile.sh 83

pause

REM
echo Clean-up for packaging...
REM
call:cleanUpPkg 

REM
echo Preparing packages...
REM
call:preparePkg

REM
echo Finding latest package and update info...
REM
C:\msys64\usr\bin\bash.exe .\grass_osgeo4w.sh  83
C:\msys64\usr\bin\bash.exe .\grass_rev_info.sh 83

REM
echo Creating standalone installer...
REM
call:createPkg

pause

REM
REM Create md5sum files
REM
REM C:\msys32\usr\bin\bash.exe .\grass_md5sum.sh 32 73
C:\msys64\usr\bin\bash.exe .\grass_md5sum.sh 83

REM
echo Building addons...
REM
REM C:\msys32\usr\bin\bash.exe .\grass_addons.sh 32
C:\msys64\usr\bin\bash.exe .\grass_addons.sh 64 82

pause 

REM
echo Publishing packages...
REM
REM C:\msys32\usr\bin\bash.exe .\grass_copy_wwwroot.sh 32
REM C:\msys64\usr\bin\bash.exe .\grass_copy_wwwroot.sh 64

exit /b %ERRORLEVEL%

:cleanUp
        REM for /d %%G in ("C:\OSGeo4W%~1\apps\grass\grass7*") do rmdir /S/Q "%%G"
exit /b 0

:cleanUpPkg
	if exist .\grass81 rmdir /S/Q .\grass81
	xcopy C:\msys64\usr\src\grass81\mswindows\*     .\grass81 /S/V/I > NUL
exit /b 0

:preparePkg
	cd .\grass81
	call .\GRASS-Packager.bat > .\GRASS-Packager.log
	cd ..
exit /b 0

:createPkg
        C:\DevTools\makensis.exe .\grass81\GRASS-Installer.nsi > .\grass81\GRASS-Installer.log
exit /b 0
