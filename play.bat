@echo off
setlocal

echo Starting cloudflared...
start "" cloudflared access tcp --hostname fiubakka.marcosrolando.uk --url 127.0.0.1:2020
set CLOUDFLARED_PID=%!

echo Starting fiubakka.exe...
start "" /wait fiubakka.exe
set FIUBAKKA_EXIT_CODE=%ERRORLEVEL%

echo Stopping cloudflared...
taskkill /PID %CLOUDFLARED_PID% /F

endlocal
exit /b %FIUBAKKA_EXIT_CODE%
