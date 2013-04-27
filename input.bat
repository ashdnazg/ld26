@ECHO off
:Start
CHOICE /C WASDQOL > NUL 2>&1
IF %ERRORLEVEL%==5 (
    DEL running.tmp > NUL 2>&1
    EXIT /b
)
IF %ERRORLEVEL%==6 ECHO.
(ECHO %ERRORLEVEL%) >input.tmp
GOTO :Start