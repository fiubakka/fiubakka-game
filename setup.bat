@echo off
setlocal

:confirm
set "response="
set /p "response=Do you want to proceed with the installation? [Y/n] "

if /i "%response%"=="Y" goto proceed
if /i "%response%"=="y" goto proceed
if "%response%"=="" goto proceed

echo Installation aborted.
exit /b

:proceed
echo Proceeding with installation...
winget install --id Cloudflare.cloudflared
endlocal
