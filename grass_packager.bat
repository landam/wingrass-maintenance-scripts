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
REM C:\msys64\usr\bin\bash.exe .\grass_compile.sh

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
REM C:\msys64\usr\bin\bash.exe .\grass_osgeo4w.sh
REM C:\msys64\usr\bin\bash.exe .\grass_rev_info.sh

REM
echo Creating standalone installer...
REM
REM call:createPkg

REM
REM Create md5sum files
REM
REM C:\msys64\usr\bin\bash.exe .\grass_md5sum.sh

REM
echo Building addons...
REM
C:\msys64\usr\bin\bash.exe .\grass_addons.sh

pause

REM
echo Publishing packages...
REM
REM C:\msys64\usr\bin\bash.exe .\grass_copy_wwwroot.sh 64

exit /b %ERRORLEVEL%

:cleanUp
        REM for /d %%G in ("C:\OSGeo4W%~1\apps\grass\grass7*") do rmdir /S/Q "%%G"
exit /b 0

:cleanUpPkg
	if exist .\grass78 rmdir /S/Q .\grass78
	xcopy C:\msys64\usr\src\grass78\mswindows\*     .\grass78 /S/V/I > NUL
	rem if exist .\grass80 rmdir /S/Q .\grass80
	rem xcopy C:\msys64\usr\src\grass80\mswindows\*     .\grass80 /S/V/I > NUL
exit /b 0

:preparePkg
	cd .\grass78
	call .\GRASS-Packager.bat > .\GRASS-Packager.log
	cd ..
	rem cd .\grass80
	rem call .\GRASS-Packager.bat > .\GRASS-Packager.log
	rem cd ..
exit /b 0

:createPkg
        C:\DevTools\makensis.exe .\grass78\GRASS-Installer.nsi > .\grass78\GRASS-Installer.log
REM        C:\DevTools\makensis.exe .\grass80\GRASS-Installer.nsi > .\grass80\GRASS-Installer.log
exit /b 0
