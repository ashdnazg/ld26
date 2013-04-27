@ECHO off
%render.Animate% OBJS
%render.Render% OBJS 0 %RENDERER.HEIGHT% > display.tmp
:Start
IF NOT EXIST running.tmp EXIT /b
IF EXIST ready.tmp GOTO :Start

SET SOUND=NOTHING
IF EXIST input.tmp FOR /F %%K IN (input.tmp) DO (
    SET SOUND=%%K
    IF %%K LEQ 4 (
        SET DIRECTION=%%K
    ) ELSE IF %%K==%FASTER_KEY% (
        SET /A SPEED-=1
    ) ELSE IF %%K==%SLOWER_KEY% (
        SET /A SPEED+=1
    )
) 
DEL input.tmp >NUL 2>&1
ECHO %SPEED% >speed.tmp

%render.Animate% OBJS
(@ECHO off & %render.Render% OBJS 0 7 > lines1.tmp) | (@ECHO off & %render.Render% OBJS 8 15 > lines2.tmp) | (@ECHO off & %render.Render% OBJS 16 %RENDERER.HEIGHT% > lines3.tmp)
COPY /B lines*.tmp display.tmp > NUL 2>&1
ECHO                SOUND: %SOUND%   SPEED: %SPEED% >> display.tmp
ECHO 1 > ready.tmp
GOTO :Start