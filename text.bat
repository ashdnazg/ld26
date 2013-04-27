::@ECHO off
:Start
CALL :%*
EXIT /b
:Init
SET text.LF=^


::Keep empty
SET ^"text.NL=^^^%text.LF%%text.LF%^%text.LF%%text.LF%^^"


EXIT /b

:StrLen
SETLOCAL EnableDelayedExpansion
SET "str=A!%~2!"
SET "len=0"
FOR /l %%A IN (12,-1,0) DO (
    SET /a "len|=1<<%%A"
    FOR %%B IN (!len!) DO IF "!str:~%%B,1!"=="" SET /a "len&=~1<<%%A"
)
FOR %%v IN (!len!) DO ENDLOCAL & IF "%%~B" NEQ "" (SET "%~1=%%v")
EXIT /b