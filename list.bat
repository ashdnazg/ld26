::@ECHO off
:Start
CALL :%*
EXIT /b
:Init
CALL INCLUDE text
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