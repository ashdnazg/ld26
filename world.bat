::@ECHO off
:Start
CALL :%*
EXIT /b
:Init
SET WORLD.UD=³
SET WORLD.DR=Ú
SET WORLD.LR=Ä
SET WORLD.DL=¿
SET WORLD.UL=Ù
SET WORLD.UR=À

SET WORLD.UP=0
SET WORLD.DOWN=1
SET WORLD.LEFT=2
SET WORLD.RIGHT=3

EXIT /b

:CreateWorldSpr <height> <width>
SET WORLD.HEIGHT=%~1
SET WORLD.WIDTH=%~2
SET /A WORLD.ROWS=WORLD.HEIGHT+2
SET /A H=%~1 + 1
SET "WORLD.BLANKROW=%WORLD.UD%"
SET "WORLD.FULLROW= "
FOR /L %%C IN (1,1,%WORLD.WIDTH%) DO (
    CALL SET "WORLD.BLANKROW=%%WORLD.BLANKROW%% "
    CALL SET "WORLD.FULLROW=%%WORLD.FULLROW%%%%WORLD.LR%%"
)
SET "WORLD.BLANKROW=%WORLD.BLANKROW%%WORLD.UD%"
SET "WORLD.FULLROW=%WORLD.FULLROW:~1%"
SET WORLD[0]=%WORLD.DR%%WORLD.FULLROW%%WORLD.DL%
SET /A WORLD[0].LEN=%WORLD.WIDTH% + 2
SET WORLD[0].START=0
FOR /L %%R IN (1,1,%WORLD.HEIGHT%) DO (
    SET WORLD[%%R]=%WORLD.BLANKROW%
    SET /A WORLD[%%R].LEN=%WORLD.WIDTH% + 2
    SET WORLD[%%R].START=0
)
SET WORLD[%H%]=%WORLD.UR%%WORLD.FULLROW%%WORLD.UL%
SET /A WORLD[%H%].LEN=%WORLD.WIDTH% + 2
SET WORLD[%H%].START=0
EXIT /b

:ShrinkWorldSpr
SET > set.set
SET /a WORLD.SHRINKDIR=%RANDOM% %% 4
IF %WORLD.SHRINKDIR%==%WORLD.UP% (
    SETLOCAL EnableDelayedExpansion
    FOR /L %%R IN (1,1,%WORLD.HEIGHT%) DO (
        SET /A NEXTROW=%%R+1
        FOR %%N IN (!NEXTROW!) DO FOR /F "delims=" %%O IN ("!WORLD[%%N]!") DO (
            ENDLOCAL
            SET "WORLD[%%R]=%%~O"
            SETLOCAL EnableDelayedExpansion
        )
    ) 
    SET /A H=%WORLD.HEIGHT%+1
    FOR %%H IN (!H!) DO (
        ENDLOCAL
        SET WORLD[%%H]=
    )
    SET /A WORLD.HEIGHT-=1
    SET /A WORLD.ROWS-=1
    SET /A WORLD.ROW+=1
) ELSE IF %WORLD.SHRINKDIR%==%WORLD.DOWN% (
    SETLOCAL EnableDelayedExpansion
    SET /A H=%WORLD.HEIGHT%+1
    FOR %%H IN (!H!) DO FOR /F "delims=" %%R IN ("!WORLD[%%H]!") DO (
        ENDLOCAL
        SET "WORLD[%WORLD.HEIGHT%]=%%~R"
        SET WORLD[%%H]=
    )
    SET /A WORLD.HEIGHT-=1
    SET /A WORLD.ROWS-=1
) ELSE IF %WORLD.SHRINKDIR%==%WORLD.LEFT% (
    SETLOCAL EnableDelayedExpansion
    SET /A H=%WORLD.HEIGHT% + 1
    FOR /L %%R IN (0,1,!H!) DO (
        SET TEMPROW="!WORLD[%%R]:~0,1!!WORLD[%%R]:~2,%WORLD.WIDTH%!"
        ECHO !H! >> temp.txt
        ECHO SET "TEMPROW=!WORLD[%%R]:~0,1!!WORLD[%%R]:~2!" >> temp.txt
        FOR /F "delims=" %%O IN ("!TEMPROW!") DO (
            ENDLOCAL
            SET "WORLD[%%R]=%%~O"
            SET /A WORLD[%%R].LEN-=1
            SETLOCAL EnableDelayedExpansion
        )
    )
    ENDLOCAL
    SET /A WORLD.WIDTH-=1
    SET /A WORLD.COL+=1
) ELSE IF %WORLD.SHRINKDIR%==%WORLD.RIGHT% (
    SETLOCAL EnableDelayedExpansion
    SET /A H=%WORLD.HEIGHT% + 1
    FOR /L %%R IN (0,1,!H!) DO (
        ECHO !H! >> temp.txt
        SET "TEMPROW=!WORLD[%%R]:~0,%WORLD.WIDTH%!!WORLD[%%R]:~-1!"
        ECHO SET TEMPROW=!WORLD[%%R]:~0,%WORLD.WIDTH%!!WORLD[%%R]:~-1! >> temp.txt
        FOR /F "delims=" %%O IN ("!TEMPROW!") DO (
            ENDLOCAL
            SET "WORLD[%%R]=%%~O"
            SET /A WORLD[%%R].LEN-=1
            SETLOCAL EnableDelayedExpansion
        )
    )
    ENDLOCAL
    SET /A WORLD.WIDTH-=1
)
SET > set.set2
EXIT /b