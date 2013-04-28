@ECHO off
:Start
IF EXIST ready.tmp (
    CLS
    IF EXIST color.tmp FOR /F %%S IN (color.tmp) DO (
        COLOR %%S
        DEL color.tmp > NUL 2>&1
    )
    TYPE display.tmp
    DEL ready.tmp > NUL 2>&1
)

IF EXIST running.tmp GOTO :Start