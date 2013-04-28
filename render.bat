::@ECHO off
:Start
CALL :%*
EXIT /b
:Init
CALL INCLUDE text
CALL INCLUDE list
CALL INCLUDE objects
SET RENDERER=1
SET RENDERER.HEIGHT=21
SET RENDERER.WIDTH=70
SET "RENDERER.BLANKROW=                                                                      "
SET RENDERER.GLOBAL_COL=-10
SET RENDERER.GLOBAL_ROW=15

EXIT /b
:Render <start_line> <end_line>
SETLOCAL EnableDelayedExpansion
SET /A STARTROW=RENDERER.GLOBAL_ROW+%~1
SET /A ENDTROW=RENDERER.GLOBAL_ROW+%~2
FOR /L %%R IN (%STARTROW%,1,%ENDTROW%) DO (
    SET "TEMPROW=%RENDERER.BLANKROW%"
    FOR %%E IN (!RENDERER[%%R]!) DO FOR /F "tokens=1,2 delims=:" %%S IN ("%%E") DO (
        SET /A BEFORE=!%%S.START! + %%T - %RENDERER.GLOBAL_COL%
        SET /A AFTER =!%%S.START! + %%T - %RENDERER.GLOBAL_COL% + !%%S.LEN!
        SET START=0
        IF 0 GEQ !BEFORE! (
            SET /A START=0 - !BEFORE!
            SET BEFORE=0
        ) ELSE IF !BEFORE! GTR %RENDERER.WIDTH% (
            SET BEFORE=%RENDERER.WIDTH%
        )
        IF 0 GEQ !AFTER! (
            SET AFTER=0
        ) ELSE IF !AFTER! GTR %RENDERER.WIDTH% (
            SET AFTER=%RENDERER.WIDTH% 
        )
        IF !START! GTR !%%S.LEN! SET START=0
        SET /A LEN=AFTER-BEFORE
        FOR %%B IN (!BEFORE!) DO FOR %%A IN (!AFTER!) DO FOR %%Z IN (!START!) DO FOR %%L IN (!LEN!) DO SET "TEMPROW=!TEMPROW:~0,%%B!!%%S:~%%Z,%%L!!!TEMPROW:~%%A!"
    )
    ECHO,!TEMPROW!
)
EXIT /b

:SpritesPerRow <objects>
FOR %%O IN (!%~1!) DO (
    FOR %%S IN (!%%O.SPRITE!) DO FOR /L %%R IN (1,1,!%%S.ROWS!) DO (
        SET /A SPRITEROW=%%R-1
        SET /A ROW=!%%O.ROW! + !SPRITEROW!
        FOR %%L IN (!ROW!) DO SET RENDERER[%%L]=!RENDERER[%%L]!,%%S[!SPRITEROW!]:!%%O.COL!;
    )
)
EXIT /b
:PlayAnimation <object> <animation>
IF "!%~1.PAUSEDANIMATION!"=="%~2" (
    SET %~1.ANIMATION=%~2
) ELSE (
    SET %~1.ANIMATION=%~2
    SET %~1.PAUSEDANIMATION=%~2
    SET %~1.NEXTFRAME=0
)
EXIT /b

:Sprite <out_sprite> <file>
SET %~1.ROWS=0
FOR /F "delims=" %%A IN (%~2)  DO (
    FOR %%R IN (!%~1.ROWS!) DO (
        SET "%~1[%%R]=%%A"
        CALL :SpriteRow %~1[%%R] "%%A"
        SET /A %~1.ROWS=%%R+1
    )
)
EXIT /b

:SpriteRow out_row text
SETLOCAL DisableDelayedExpansion
SET "TEXT=%~2"
%text.StrLen% LENTOTAL TEXT
FOR /F "delims=" %%T IN ('ECHO ^| SET /p .^="%~2"') DO (
    SET STRIPPED=%%T
    %text.StrLen% LENSTRIPPED STRIPPED
)
ENDLOCAL & (
SET "%~1=%STRIPPED%"
SET /A %~1.START=%LENTOTAL%-%LENSTRIPPED%
SET /A %~1.LEN=%LENSTRIPPED%
)
EXIT /b


:Animation <out_animation> <Sprite files...>
SETLOCAL EnableDelayedExpansion

SET N=-1
FOR %%S IN (%*) DO (
    IF !N! NEQ -1 (
        FOR %%N IN (!N!) DO ENDLOCAL & (
            CALL :Sprite %1[%%N] %%S
            SETLOCAL EnableDelayedExpansion
            SET /A N=%%N+1
        )
    ) ELSE SET /A N=!N!+1
)
ENDLOCAL & SET /A %~1.LEN=%N%
EXIT /b

:PauseAnimation <object>
SET %~1.ANIMATION=
EXIT /b

:StopAnimation
SETLOCAL EnableDelayedExpansion 
FOR %%S IN (!%~1.ORIGINALSPRITE!) DO ENDLOCAL &(
    SET %~1.ANIMATION=
    SET %~1.PAUSEDANIMATION=
    SET %~1.SPRITE=%%S
)
EXIT /b

:Animate <objects>
REM SETLOCAL EnableDelayedExpansion
FOR %%O IN (!%~1!) DO IF "!%%O.ANIMATION!" NEQ "" FOR %%A IN (!%%O.ANIMATION!) DO FOR %%N IN (!%%O.NEXTFRAME!) DO FOR %%L IN (!%%A.LEN!) DO ENDLOCAL &(
    SET %%O.SPRITE=%%A[%%N]
    SET /A %%O.NEXTFRAME+=1
    SET /A %%O.NEXTFRAME%%=%%L
    REM SETLOCAL EnableDelayedExpansion
)
REM ENDLOCAL
EXIT /b
