::@ECHO off
:Start
CALL :%*
EXIT /b
:Init
SET text.LF=^


::Keep empty
SET ^"text.NL=^^^%text.LF%%text.LF%^%text.LF%%text.LF%^^"

FOR /F %%C in ('COPY /z "%~dpnx0" NUL') DO SET text.CR=%%C

COPY NUL sub.tmp /a > NUL
FOR /F %%A IN (sub.tmp) DO (
   SET "text.SUB=%%A"
)
DEL sub.tmp



SET @text.StrLen=FOR %%n IN (1 2) DO IF %%n==2 (%text.NL%
      FOR /F "tokens=1,2 delims=, " %%1 IN ("!argv!") DO (%text.NL%
         SET "str=A!%%~2!"%text.NL%
           SET "len=0"%text.NL%
           FOR /l %%A IN (12,-1,0) DO (%text.NL%
             SET /a "len|=1<<%%A"%text.NL%
             FOR %%B IN (!len!) DO IF "!str:~%%B,1!"=="" SET /a "len&=~1<<%%A"%text.NL%
           )%text.NL%
           FOR %%v IN (!len!) DO ENDLOCAL^&IF "%%~B" NEQ "" (SET "%%~1=%%v")%text.NL%
      ) %text.NL%
) ELSE SETLOCAL enableDelayedExpansion ^& SET argv=,

SET @text.Put=FOR %%n IN (1 2) DO IF %%n==2 (%text.NL%
      FOR /F "tokens=1 delims=," %%1 IN ("!argv!") DO (%text.NL%
         ^<NUL SET /p ".=%%1"%text.NL%
         ENDLOCAL%text.NL%
      ) %text.NL%
) ELSE SETLOCAL enableDelayedExpansion ^& SET argv=,

SET @text.PutCR=FOR %%n IN (1 2) DO IF %%n==2 (%text.NL%
      FOR /F "tokens=1 delims=," %%1 IN ("!argv!") DO (%text.NL%
         ^<NUL SET /p ".=%%1!text.CR!"%text.NL%
         ENDLOCAL%text.NL%
      ) %text.NL%
) ELSE SETLOCAL enableDelayedExpansion ^& SET argv=,

SET @text.SuperPut=FOR %%n IN (1 2) DO IF %%n==2 (%text.NL%
      FOR /F "tokens=1 delims=," %%1 IN ("!argv!") DO (%text.NL%
         ^> txt.tmp (ECHO(%%~1!text.SUB!)%text.NL%
         COPY txt.tmp /a txt2.tmp /b ^> NUL%text.NL%
         TYPE txt2.tmp%text.NL%
         DEL txt.tmp txt2.tmp%text.NL%
         ENDLOCAL%text.NL%
      ) %text.NL%
) ELSE SETLOCAL enableDelayedExpansion ^& SET argv=,


EXIT /b