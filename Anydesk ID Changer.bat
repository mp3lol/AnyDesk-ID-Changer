@echo off&mode 80,25&title AnyDesk ID Changer
IF not "%1"=="am_admin" (powershell start -verb runas '%0' am_admin & exit /b)
IF not exist "C:\Program Files (x86)\AnyDesk\AnyDesk.exe" echo [-] Anydesk is not installed&timeout /t 99999 /nobreak>NUL
IF not exist "C:\ProgramData\AnyDesk\service.conf" echo [-] Open AnyDesk and try again&timeout /t 99999 /nobreak>NUL
IF not exist "C:\ProgramData\AnyDesk\system.conf" echo [-] Open AnyDesk and try again&timeout /t 99999 /nobreak>NUL
tasklist /fi "ImageName eq AnyDesk.exe" /fo csv 2>nul | find /I "AnyDesk.exe">NUL 2>&1
IF "%ERRORLEVEL%"=="0" taskkill /F /T /IM AnyDesk.exe>NUL 2>&1
echo [*] Terminating AnyDesk
<"C:\ProgramData\AnyDesk\system.conf" find "ad.anynet.id=" > "%temp%\anydesk.txt"
echo [*] Setting variables
for /f "delims=" %%x in ("%temp%\anydesk.txt") do set anydesk=%%x
set /p anycode=<%anydesk%
powershell -Command "(gc C:\ProgramData\AnyDesk\system.conf) -replace '%anycode%', '' | Out-File -encoding ASCII C:\ProgramData\AnyDesk\system.conf"
echo [*] Removing Old Code
taskkill /F /T /IM AnyDesk.exe>NUL 2>&1
del /f /q "C:\ProgramData\AnyDesk\system.conf">NUL 2>&1
del /f /q "C:\ProgramData\AnyDesk\service.conf">NUL 2>&1
del /f /q "%anydesk%">NUL 2>&1
echo [*] Cleaning Junk
echo [+] Succesfully changed AnyDesk ID&start C:\"Program Files (x86)"\AnyDesk\AnyDesk.exe&timeout /t 10 /nobreak>NUL&exit /b