Readme file for RVT2RVL v0.2
Developed by techboy, August 2010
---------------------------------------

RVT2RVL is a simple tool to convert development wii WAD files into
WAD files that work with retail wiis.

DISCLAIMER:
------------------------------

THIS SOFTWARE COMES 'AS-IS', WITH NO WARRANTIES WHATSOEVER,
NEITHER EXPRESS NOR IMPLIED. THIS SOFTWARE MAY BRICK YOUR 
WII IF MISUSED. I AM NOT RESPONSIBLE FOR ANY BRICKED WII
CONSOLES OR DATA LOSS THAT MAY RESULT.

Initial Setup:
------------------------------

This tool has been tested on WinXP SP3 32-Bit. Users of 0.1 report success on Windows 7 32-bit, but
no official testing was performed on this OS.

Place this tool in its own folder! Failure to do so may result in strange behavior or data loss.

You need to provide the RVTKey.bin file, which contains the common key used
on Development Wiis. You can find this online in a torrent called 
RVT.Development.Key.RVT.Wii-OneUp_iNT. Rename the dev-key.bin to RVTkey.bin.

You also need an internet connection the first (and ONLY the first) time you use
the tool, so it can generate the certifcate file (cert.rvl). This is done by downloading the
IOS4 v65280 stub from NUS.

You do NOT need to provide the common key. The script will ask you to create this using
MakeKeyBin the first time you use it.

Usage:
-------------------------------

Just drag an RVT wad (or multiple wads) onto the RVT2RVL script. Output files are named the 
same as the input, but with an [RVL] prefix. The file will be converted automatically.

If your input was called "MenuUninstaller.wad", output would be: "[RVL]MenuUninstaller.wad"

For those interested in what EXACTLY is performed: The tool unpacks the RVT wad using the dev key, 
replaces the certificate data with the retail version, fixes the references to these certs in TMD 
and Ticket, packs the wad backup using the normal common key, and trucha signs it. The resulting 
wad works like any normal wad. Install it with cIOS or other trucha-enabled IOS.

Changelog
-------------------------------

v0.2:

* Fixed critical bug which would result in data loss if wad unpacking failed.
* Fixed bug which prevented tool from working when input files were not stored on same
drive as the user's profile.
* Documentation update
* Disclaimer update
* Additional testing.

v0.1:
* Initial Release


Credits:
-------------------------------
First, big thanks go to OneUp for releasing the dev titles to the public. 
This tool would be pointless (and impossible!) otherwise.

Other credit goes to:
* The developers of BFGR WAD Tools.
* WB3000 for NUSD and WiiNinja for CMD version.
* The maker of WADDataInfo.
* The maker of MakeKeyBin.
* The users on GBATemp for reporting the data loss bug and trying RVT2RVL on Win7.