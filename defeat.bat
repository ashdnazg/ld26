@ECHO off
SETLOCAL EnableDelayedExpansion

ECHO                             GAME OVER.
ECHO.
ECHO                            SCORE: %obj_player.COL%
ECHO.
IF %KILLS% GTR 0 (
    ECHO NOT ONLY HAVE YOU LOST, YOU HAVE ALSO TURNED ON %KILLS% OF YOUR OWN PEOPLE.
)
CALL :GetRandom adjectives.str ADJ
CALL :GetRandom jobs.str JOB
ECHO.
ECHO Together with the few surviving stickpeople you've been transformed.
ECHO.
ECHO From now on you exist as: @ - %ADJ% %JOB%
ECHO.
ECHO Press q to quit
ENDLOCAL
EXIT /b



:GetRandom <filename> <out_random_line>
FOR /F %%C IN ('type %1 ^| find /V /C ""') DO SET NUM_LINES=%%C
SET /A LINE_INDEX=%RANDOM% %% %NUM_LINES% 
SET INDEX=0
FOR /F "delims=" %%L IN ('type %1') DO (
    IF !INDEX!==!LINE_INDEX! (
        SET %~2=%%L
        Exit /b
    )
    SET /A INDEX+=1
)
EXIT /b