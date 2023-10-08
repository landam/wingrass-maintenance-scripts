@echo on

set HOME=C:\Users\landamar\grass_packager
cd %HOME%

REM
echo Clean-up...
REM
call :cleanUp

REM
echo Compiling GRASS GIS...
REM
C:\msys64\usr\bin\bash.exe .\grass_compile.sh

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
C:\msys64\usr\bin\bash.exe .\grass_osgeo4w.sh
C:\msys64\usr\bin\bash.exe .\grass_rev_info.sh

REM
echo Creating standalone installer...
REM
call:createPkg

REM
REM Create md5sum files
REM
C:\msys64\usr\bin\bash.exe .\grass_md5sum.sh

REM
echo Building addons...
REM
C:\msys64\usr\bin\bash.exe .\grass_addons.sh

REM
echo Publishing packages...
REM
C:\msys64\usr\bin\bash.exe .\grass_copy_scp.sh

exit /b %ERRORLEVEL%

:cleanUp
        REM for /d %%G in ("C:\OSGeo4W%~1\apps\grass\grass7*") do rmdir /S/Q "%%G"
exit /b 0

:cleanUpPkg
	if exist .\grass83 rmdir /S/Q .\grass83
	xcopy C:\msys64\usr\src\grass83\mswindows\*     .\grass83 /S/V/I > NUL
	if exist .\grass84 rmdir /S/Q .\grass84
	xcopy C:\msys64\usr\src\grass84\mswindows\*     .\grass84 /S/V/I > NUL
exit /b 0

:preparePkg
	cd .\grass83
	call .\GRASS-Packager.bat > .\GRASS-Packager.log
	cd ..
	cd .\grass84
	call .\GRASS-Packager.bat > .\GRASS-Packager.log
	cd ..
exit /b 0

:createPkg
	C:\DevTools\makensis.exe .\grass83\GRASS-Installer.nsi > .\grass83\GRASS-Installer.log
	C:\DevTools\makensis.exe .\grass84\GRASS-Installer.nsi > .\grass84\GRASS-Installer.log
exit /b 0
