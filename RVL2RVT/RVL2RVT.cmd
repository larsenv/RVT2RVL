echo off
cls
title RVL2RVT - Retail to Dev WAD Convertor

echo RVL2RVT Conversion Script
echo By Larsenv.
echo Original script by Techboy.
echo.

if "%~dp1"=="" goto usage

%~d0
cd %~dp0

echo DISCLAIMER: THIS SOFTWARE COMES 'AS-IS', WITH NO WARRANTIES WHATSOEVER,
ECHO             NEITHER EXPRESS NOR IMPLIED. THIS SOFTWARE MAY BRICK YOUR 
ECHO             WII IF MISUSED. I AM NOT RESPONSIBLE FOR ANY BRICKED WII
ECHO             CONSOLES OR LOST DATA THAT MAY RESULT.
ECHO.
ECHO             IT IS YOUR RESPONSIBILITY TO PROTECT YOUR CONSOLE FROM
ECHO             A BRICK.
:_nextfile
ECHO.
ECHO Current Directory is: %CD%
ECHO Path of incoming file: %1
ECHO.
:_begin
if exist .\tmp rd /S /Q .\tmp
if exist .\0* rd /S /Q .\0*

if not exist .\rvtkey.bin goto _rvtkey
if not exist .\tmp md .\tmp
if not exist .\bin\common-key.bin goto _keys
if not exist .\common-key.bin goto _keys
if not exist .\cert.rvl goto _makecert

if exist .\retail.key (
	ren .\common-key.bin rvtkey.bin
	ren .\retail.key common-key.bin
)

copy /Y %1 .\incoming.wad
ren .\common-key.bin retail.key
ren .\rvtkey.bin common-key.bin

echo RVL2RVT: Unpacking RVT Title

echo RVL2RVT: Unpacking RVL Title
bin\bfgr_wadunpacker.exe .\incoming.wad

cd 0*
move /Y *.* ..\tmp > NUL
set dirkill=%cd%
echo.
echo RVL2RVT: Removing Empty Folder
cd..
rd "%dirkill%"
set dirkill=
del .\incoming.wad

echo RVL2RVT: Renaming files
ren .\tmp\*.tmd title.tmd
ren .\tmp\*.tik title.tik
ren .\tmp\*.trailer title.trailer
del .\tmp\*.cert

if exist .\retail.key (
	ren .\common-key.bin rvtkey.bin
	ren .\retail.key common-key.bin
)

echo RVL2RVT: Replacing certificate file
copy /Y .\cert.rvt .\tmp\title.cert
echo RVL2RVT: Correcting certificate chain in Ticket
bin\hexalter.exe .\tmp\title.tik 0x14e=0x33 0x159=0x31
echo RVL2RVT: Correcting certificate chain in TMD
bin\hexalter.exe .\tmp\title.tmd 0x14e=0x34 0x159=0x31
echo.
echo RVL2RVT: Packing WAD file
copy .\RVTKey.bin .\tmp\common-key.bin
copy .\bin\bfgr_wadpacker.exe .\tmp
copy .\bin\cyg*.* .\tmp
cd .\tmp
bfgr_wadpacker.exe .\title.tik .\title.tmd .\title.cert ..\outgoing.wad -sign -w
cd ..
if not exist .\outgoing.wad (
	echo FATAL: Failure while packing wad!
	echo.
	echo Press any key to exit
	pause > NUL
	goto end
)
copy /Y ".\outgoing.wad" "%~dp1[RVT]%~nx1"
echo _____________________________________________
echo.
echo RVL2RVT: Conversion succeeded! The following is the TMD information for
echo          your wad.
bin\waddatainfo.exe /n .\outgoing.wad
del .\outgoing.wad
shift /1
if not "%~dp1"=="" goto _nextfile
rd /S /Q .\tmp
pause
goto end
:_keys
if exist .\bin\common-key.bin del .\bin\common-key.bin
if exist .\common-key.bin del .\common-key.bin
echo WARN: Common-key not found!
bin\makekeybin.exe
copy .\key.bin bin\common-key.bin
ren .\key.bin common-key.bin
del .\kkey.bin > NUL
echo RVL2RVT: Created a common-key.bin
if exist .\common-key.bin goto _begin
echo.
echo FATAL: Failed to create common-key.bin!
echo.
echo Obtain common-key.bin and place it in the 'bin' subfolder. Also, place
echo a second copy in the folder alongside the RVL2RVT script. Then
echo try the conversion again.
go

:_rvtkey
echo FATAL: RVT Wii Key is missing. Obtain a copy of the RVT wii key, and
echo        place it in the folder with this script, named RVTKey.bin
echo.
echo Press any key to exit
pause > NUL
goto end

:usage
echo USAGE: Drag the WAD file to be converted onto this script.
echo.
echo Press any key to exit...
pause > NUL
goto end

:_makecert
echo RVL2RVT: Creating cert.rvl - This requires a network connection
echo          This procedure should only happen once.
echo.
.\bin\NUSD 0000000100000004 65280
if not exist .\bin\0000000100000004\0000000100000004.wad (
	echo ERROR: Failed to download required title from NUS!
	echo        This title is needed to create a certificate file.
	echo.
	echo        Please connect to the internet and try again.
	echo        Press any key to exit
	pause > NUL
	goto end
)
move /Y .\bin\0000000100000004\0000000100000004.wad .\IOS4.wad
bin\bfgr_wadunpacker.exe .\IOS4.wad
copy .\0000000100000004\0000000100000004.cert .\cert.rvl
rd /S /Q .\bin\0000000100000004
rd /S /Q .\0000000100000004
del .\IOS4.wad

if not exist .\cert.rvl (
	echo ERROR: Failed to create a certificate file.
	echo.
	echo        Extract the cert from a wad manually, name it
	echo        cert.rvl, and place it in the folder with RVL2RVT.
	echo.
	echo        Press any key to exit
	pause > NUL
	goto end
)
cd %~dp0
REM echo RVL2RVT: Cert.rvl was created successfully!
REM echo          Press any key to continue with conversion.
REM pause > NUL
goto _begin

:end
if exist .\retail.key (
	ren .\common-key.bin rvtkey.bin
	ren .\retail.key common-key.bin
)