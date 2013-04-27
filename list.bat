::@ECHO off
:Start
CALL :%*
EXIT /b
:Init
CALL INCLUDE text

SET @list.GetIterator=FOR %%n IN (1 2) DO IF %%n==2 (%text.NL%
      FOR /F "tokens=1,2 delims=, " %%1 IN ("!argv!") DO (%text.NL%
         SET NEXT=!%%~1.HEAD.NEXT!%text.NL%
         FOR %%E in (!NEXT!) DO ENDLOCAL^&(SET %%~2.CURITEM=%%E)%text.NL%
      ) %text.NL%
) ELSE SETLOCAL enableDelayedExpansion ^& SET argv=,

SET @list.IteratorNext=FOR %%n IN (1 2) DO IF %%n==2 (%text.NL%
      FOR /F "tokens=1,2 delims=, " %%1 IN ("!argv!") DO (%text.NL%
         SET CURITEM=!%%~1.CURITEM!%text.NL%
         IF !CURITEM!==NONE (%text.NL%
             ENDLOCAL^&SET %%~2=NONE%text.NL%
         ) ELSE (%text.NL%
             FOR %%C in (!CURITEM!) DO (%text.NL%
                 ENDLOCAL%text.NL%
                 CALL CALL SET %%~2=%%%%%%C.VALUE%%%%%text.NL%
                 CALL CALL SET %%~1.CURITEM=%%%%%%C.NEXT%%%%%text.NL%
             )%text.NL%
         )%text.NL%
      )%text.NL%
) ELSE SETLOCAL enableDelayedExpansion ^& SET argv=,

SET @list.GetAll=FOR %%n IN (1 2) DO IF %%n==2 (%text.NL%
      FOR /F "tokens=1,2 delims=, " %%1 IN ("!argv!") DO (%text.NL%
         SET CURITEM=%%~1.HEAD%text.NL%
         SET ALLITEMS=%text.NL%
         FOR /L %%K IN (1,1,!%%~1.LEN!) DO (%text.NL%
             IF !CURITEM! NEQ NONE (%text.NL%
                FOR %%C IN (!CURITEM!) DO SET CURITEM=!%%C.NEXT!%text.NL%
                FOR %%C IN (!CURITEM!) DO SET ALLITEMS=!ALLITEMS!,!%%C.VALUE!%text.NL%
             )%text.NL%
         )%text.NL%
         FOR /F "delims=" %%I in ("!ALLITEMS!") DO ENDLOCAL^&(SET %%~2=%%I)%text.NL%
      ) %text.NL%
) ELSE SETLOCAL enableDelayedExpansion ^& SET argv=,


SET @list.New=FOR %%n IN (1 2) DO IF %%n==2 (%text.NL%
    FOR /F "tokens=1 delims=, " %%1 IN ("!argv!") DO (%text.NL%
        ENDLOCAL^&(%text.NL%
        SET %%~1.HEAD.NEXT=NONE%text.NL%
        SET %%~1.HEAD.VALUE=NONE%text.NL%
        SET %%~1.LEN=0%text.NL%
        SET %%~1.ID=0%text.NL%
        )%text.NL%
    ) %text.NL%
) ELSE SETLOCAL enableDelayedExpansion ^& SET argv=,

SET @list.Add=FOR %%n IN (1 2) DO IF %%n==2 (%text.NL%
    FOR /F "tokens=1,2 delims=, " %%1 IN ("!argv!") DO (%text.NL%
        SET CURITEM=%%~1.HEAD%text.NL%
        FOR /L %%O IN (1,1,!%%~1.LEN!) DO FOR %%C IN (!CURITEM!) DO SET CURITEM=!%%C.NEXT!%text.NL%
        SET NEWNODE=%%~1_!%%~1.ID!%text.NL%
        FOR %%O IN (!NEWNODE!) DO FOR %%C IN (!CURITEM!) DO ENDLOCAL^&(%text.NL%
            SET %%C.NEXT=%%O%text.NL%
            SET %%O.PREV=%%C%text.NL%
            SET %%O.VALUE=%%~2%text.NL%
            SET %%O.NEXT=NONE%text.NL%
            SET /A %%~1.ID=%%~1.ID + 1%text.NL%
            SET /A %%~1.LEN=%%~1.LEN + 1%text.NL%
        )%text.NL%
    ) %text.NL%
) ELSE SETLOCAL enableDelayedExpansion ^& SET argv=,

SET @list.IndexOf=FOR %%n IN (1 2) DO IF %%n==2 (%text.NL%
    FOR /F "tokens=1,2,3 delims=, " %%1 IN ("!argv!") DO (%text.NL%
        SET CURITEM=%%~1.HEAD%text.NL%
        SET INDEX=-1%text.NL%
        FOR /L %%O in (0,1,!%%~1.LEN!) DO (%text.NL%
            IF !INDEX!==-1 (%text.NL%
                IF !CURITEM! NEQ NONE (%text.NL%
                    FOR %%C IN (!CURITEM!) DO SET CURITEM=!%%C.NEXT!%text.NL%
                    FOR %%C IN (!CURITEM!) DO IF "!%%C.VALUE!"=="%%~2" SET INDEX=%%O%text.NL%
                )%text.NL%
            )%text.NL%
        )%text.NL%
        FOR %%I IN (!INDEX!) DO ENDLOCAL^&SET %%~3=%%I%text.NL%
    ) %text.NL%
) ELSE SETLOCAL enableDelayedExpansion ^& SET argv=,

SET @list.Swap=FOR %%n IN (1 2) DO IF %%n==2 (%text.NL%
    FOR /F "tokens=1,2,3 delims=, " %%1 IN ("!argv!") DO (%text.NL%
        SET CURITEM=%%~1.HEAD%text.NL%
        SET ITEM1=-1%text.NL%
        SET ITEM2=-1%text.NL%
        FOR /L %%O in (0,1,!%%~1.LEN!) DO (%text.NL%
            IF !CURITEM! NEQ NONE (%text.NL%
                FOR %%C IN (!CURITEM!) DO SET CURITEM=!%%C.NEXT!%text.NL%
                FOR %%C IN (!CURITEM!) DO (%text.NL%
                    IF !ITEM1!==-1 IF "!%%C.VALUE!"=="%%~2" SET ITEM1=%%C%text.NL%
                    IF !ITEM2!==-1 IF "!%%C.VALUE!"=="%%~3" SET ITEM2=%%C%text.NL%
                )%text.NL%
            )%text.NL%
        )%text.NL%
        FOR %%I IN (!ITEM1!) DO FOR %%J IN (!ITEM2!) DO FOR %%A IN (!%%I.VALUE!) DO FOR %%B IN (!%%J.VALUE!) DO ENDLOCAL^&(%text.NL%
            SET %%I.VALUE=%%B%text.NL%
            SET %%J.VALUE=%%A%text.NL%
        )%text.NL%
    )%text.NL%
) ELSE SETLOCAL enableDelayedExpansion ^& SET argv=,
EXIT /b

:New <out_list>
SET %~1.HEAD.NEXT=NONE
SET %~1.HEAD.VALUE=NONE
SET %~1.LEN=0
SET %~1.ID=0
EXIT /b

:Add <list> <var>
SETLOCAL EnableDelayedExpansion
SET CURITEM=%~1.HEAD
FOR /L %%N in (1,1,!%~1.LEN!) DO (
    CALL SET CURITEM=%%!CURITEM!.NEXT%%
)
SET NEWNODE=%~1_!%~1.ID!
ENDLOCAL & (
SET %CURITEM%.NEXT=%NEWNODE%
SET %NEWNODE%.PREV=%CURITEM%
SET %NEWNODE%.VALUE=%2
SET %NEWNODE%.NEXT=NONE
SET /A %~1.ID=%~1.ID + 1
SET /A %~1.LEN=%~1.LEN + 1
)
EXIT /b

:GetValueAt <list> <pos> <out_value>
SETLOCAL EnableDelayedExpansion
SET CURITEM=%~1.HEAD

FOR /L %%N in (0,1,%~2) DO (
    IF !CURITEM! NEQ NONE CALL SET CURITEM=%%!CURITEM!.NEXT%%
)
IF %CURITEM%==NONE (
    ENDLOCAL & SET "%~3=NONE"
)ELSE (
    ENDLOCAL & CALL SET "%~3=%%%CURITEM%.VALUE%%%
)
EXIT /b

:RemoveAt <list> <pos>
SETLOCAL EnableDelayedExpansion
SET CURITEM=%~1.HEAD

FOR /L %%N in (0,1,%~2) DO (
    IF !CURITEM! NEQ NONE CALL SET CURITEM=%%!CURITEM!.NEXT%%
)
ENDLOCAL & IF %CURITEM% NEQ NONE (
    CALL SET %%%CURITEM%.PREV%%.NEXT=%%%CURITEM%.NEXT%%%
    CALL SET %%%CURITEM%.NEXT%%.PREV=%%%CURITEM%.PREV%%
    SET %CURITEM%.VALUE=
    SET %CURITEM%.NEXT=
    SET %CURITEM%.PREV=
    SET /A %~1.LEN=%~1.LEN - 1
)
EXIT /b

:IndexOf <list> <value> <out_index>
SETLOCAL EnableDelayedExpansion
SET CURITEM=%~1.HEAD
SET INDEX=-1
FOR /L %%N in (0,1,!%~1.LEN!) DO (
    IF !INDEX!==-1 (
        IF !CURITEM! NEQ NONE CALL SET CURITEM=%%!CURITEM!.NEXT%%
        CALL SET VALUE=%%!CURITEM!.VALUE%%
        IF "!VALUE!"=="%~2" SET /A INDEX=%%N
    )
)
ENDLOCAL & SET %~3=%INDEX%

EXIT /b

:GetIterator <list> <out_iter>
CALL SET %~2.CURITEM=%%%~1.HEAD.NEXT%%
EXIT /b

:IteratorNext <iter> <out_val>

SETLOCAL EnableDelayedExpansion
SET CURITEM=!%~1.CURITEM!
IF %CURITEM%==NONE (
    ENDLOCAL & SET %~2=NONE
) ELSE (
    ENDLOCAL & (
    CALL SET %~2=%%%CURITEM%.VALUE%%
    CALL SET %~1.CURITEM=%%%CURITEM%.NEXT%%
    )
)
EXIT /b