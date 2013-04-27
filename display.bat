@ECHO off
CALL INCLUDE timeops
:Start
IF EXIST ready.tmp (
    CLS
    TYPE display.tmp
    DEL ready.tmp > NUL 2>&1
)
IF EXIST color.tmp FOR /F %%S IN (color.tmp) DO (
        COLOR %%S
        DEL color.tmp > NUL 2>&1
)

REM IF EXIST speed.tmp FOR /F %%S IN (speed.tmp) DO (
        REM SET SPEED=%%S
        REM DEL speed.tmp > NUL 2>&1
REM ) > NUL 2>&1
REM %timeops.Wait% %SPEED%
IF EXIST running.tmp GOTO :Start
COLOR 07