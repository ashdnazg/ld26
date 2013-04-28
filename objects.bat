::@ECHO off
:Start
CALL :%*
EXIT /b
:Init
SET OBJECTS_LIST=,
SET OBJECTS_LIST.CHANGED=0
SET KILL_LIST=,
SET STOP_LIST=,
SET VULNERABLE_LIST=,
EXIT /b

:Sort
IF %OBJECTS_LIST.CHANGED%==1 (
    ECHO. > objects.tmp
    FOR %%O IN (%OBJECTS_LIST%) DO (
        SET /A Z=11000 + %%O.ROW + %%O.DELTA.BOTTOM_ROW + %%O.DELTA.Z
        ECHO !Z:~1!,%%O >> objects.tmp
    )
    SET ALLITEMS=,
    FOR /F "tokens=1,2 delims=," %%K IN ('sort objects.tmp') DO (
        SET ALLITEMS=!ALLITEMS!,%%L
    )
    FOR %%A IN ("!ALLITEMS!") DO (
        SET "OBJECTS_LIST=%%~A"
        SET OBJECTS_LIST.CHANGED=0 
    )
)
EXIT /b
:CheckMove <object> <list> <out_result>
FOR %%O IN (!%~2_LIST!) DO (
    IF "%%O" NEQ "%~1" (
        SET /A TEST=%~1.ROW + %~1.DELTA.TOP_ROW - %%O.ROW - %%O.DELTA.BOTTOM_ROW
        IF 0 GTR !TEST! (
            SET /A TEST=%%O.ROW + %%O.DELTA.TOP_ROW - %~1.ROW - %~1.DELTA.BOTTOM_ROW
            IF 0 GTR !TEST! (         
                SET /A TEST=%~1.COL + %~1.DELTA.LEFT_COL - %%O.COL - %%O.DELTA.RIGHT_COL
                IF 0 GTR !TEST! (
                    SET /A TEST=%%O.COL + %%O.DELTA.LEFT_COL - %~1.COL - %~1.DELTA.RIGHT_COL
                    IF 0 GTR !TEST! (
                        SET %~3=%%O
                        EXIT /b
                    )
                )
            )
        )
    )
)
SET %~3=NONE
Exit /b
:CheckCollisions <object1> <object2> <out_collision>
SET /A TEST=%~1.ROW + %~1.DELTA.TOP_ROW - %~2.ROW - %~2.DELTA.BOTTOM_ROW
IF %TEST% GEQ 0 (
    SET %~3=0
    EXIT /b
)
SET /A TEST=%~2.ROW + %~2.DELTA.TOP_ROW - %~1.ROW - %~1.DELTA.BOTTOM_ROW
IF %TEST% GEQ 0 (
    SET %~3=0
    EXIT /b
)
SET /A TEST=%~1.COL + %~1.DELTA.LEFT_COL - %~2.COL - %~2.DELTA.RIGHT_COL
IF %TEST% GEQ 0 (
    SET %~3=0
    EXIT /b
)
SET /A TEST=%~2.COL + %~2.DELTA.LEFT_COL - %~1.COL - %~1.DELTA.RIGHT_COL
IF %TEST% GEQ 0 (
    SET %~3=0
    EXIT /b
)
SET %~3=1
EXIT /b

:SetRandomLocation <object> <min_row> <min_col> <max_row> <max_col> <height> <width>
SET /A %~1.ROW=%RANDOM% %% (%~4 - %~2 - %~6) + %~2
SET /A %~1.COL=%RANDOM% %% (%~5 - %~3 - %~7) + %~3
FOR %%O IN (%OBJECTS_LIST%) DO (
    IF "%%O" NEQ "%~1" (
        CALL :CheckCollisions %~1 %%O COLLIDES
        IF !COLLIDES!==1 (
            GOTO :SetRandomLocation
        )
    )
)
EXIT /b

:Object <out_object> <sprite> <row> <col> <top_row> <left_col> <bottom_row> <right_col> <z>
SET %~1.SPRITE=%~2
SET %~1.ORIGINALSPRITE=%~2
SET %~1.ROW=%~3
SET %~1.COL=%~4
SET %~1.DELTA.TOP_ROW=%~5
SET %~1.DELTA.LEFT_COL=%~6
SET %~1.DELTA.BOTTOM_ROW=%~7
SET %~1.DELTA.RIGHT_COL=%~8
SET %~1.DELTA.Z=%~9
SET NAME=%1
SHIFT
SHIFT
SHIFT
IF "%~9" NEQ "RESERVE" (
    SET OBJECTS_LIST=%OBJECTS_LIST%,%NAME%
    SET OBJECTS_LIST.CHANGED=1
    IF "%~7"=="KILL" SET KILL_LIST=%KILL_LIST%,%NAME%
    IF "%~7"=="STOP" SET STOP_LIST=%STOP_LIST%,%NAME%
    IF "%~8"=="VULNERABLE" SET VULNERABLE_LIST=%VULNERABLE_LIST%,%NAME%
)


EXIT /b

