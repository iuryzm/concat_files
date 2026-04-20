@echo off
echo Processando arquivos do .gitignore...
echo.
powershell -ExecutionPolicy Bypass -File "concat_files.ps1"
echo.
pause
