@ECHO off
CALL INCLUDE timeops
:Start
IF EXIST ready.tmp (
    CLS
    TYPE display.tmp
    DEL ready.tmp > NUL 2>&1
)
IF EXIST speed.tmp FOR /F %%S IN (speed.tmp) DO (
        SET SPEED=%%S
        DEL speed.tmp > NUL 2>&1
) > NUL 2>&1
%timeops.Wait% %SPEED%
IF EXIST running.tmp GOTO :Start
