@echo off
setlocal enabledelayedexpansion
chcp 65001 >nul

set "BASE_DIR=%~dp0"
set "INCOMING_DIR=%BASE_DIR%incoming"
set "ASSETS_DIR=%BASE_DIR%assets"

echo.
echo Updating GitHub Pages content...
echo.

if not exist "%INCOMING_DIR%" (
  echo Folder not found: "%INCOMING_DIR%"
  pause
  exit /b 1
)

if not exist "%ASSETS_DIR%" (
  echo Folder not found: "%ASSETS_DIR%"
  pause
  exit /b 1
)

set "UPDATED=0"

call :copy_one screen1 .mp4
call :copy_one screen1 .webm
call :copy_one screen1 .jpg
call :copy_one screen1 .jpeg
call :copy_one screen1 .png
call :copy_one screen1 .webp
call :copy_one screen1 .gif

call :copy_one screen2 .mp4
call :copy_one screen2 .webm
call :copy_one screen2 .jpg
call :copy_one screen2 .jpeg
call :copy_one screen2 .png
call :copy_one screen2 .webp
call :copy_one screen2 .gif

echo.
if "%UPDATED%"=="0" (
  echo No new files found in "%INCOMING_DIR%".
) else (
  echo GitHub Pages assets updated.
  echo Commit and push the changes to publish them.
)
echo.
pause
exit /b 0

:copy_one
set "NAME=%~1"
set "EXT=%~2"
set "SRC=%INCOMING_DIR%\%NAME%%EXT%"

if exist "%SRC%" (
  for %%E in (.mp4 .webm .jpg .jpeg .png .webp .gif) do (
    if /i not "%%~E"=="%EXT%" (
      if exist "%ASSETS_DIR%\%NAME%%%~E" del /f /q "%ASSETS_DIR%\%NAME%%%~E" >nul 2>nul
    )
  )
  copy /y "%SRC%" "%ASSETS_DIR%\%NAME%%EXT%" >nul
  echo Updated %NAME%%EXT%
  set "UPDATED=1"
)
goto :eof
