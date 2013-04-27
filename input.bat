@ECHO off
:Start
CHOICE /C WASDHOLQ > NUL 2>&1
IF %ERRORLEVEL%==%QUIT_KEY% (
    DEL running.tmp > NUL 2>&1
    EXIT /b
)
(ECHO %ERRORLEVEL%) >input.tmp
GOTO :Start