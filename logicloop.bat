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
        IF %DIRECTION% NEQ %%K (
            SET obj_player.ANIMATION=
            SET DIRECTION=%%K
        ) ELSE SET DIRECTION=NONE
    ) ELSE IF %%K==%FASTER_KEY% (
        SET /A SPEED-=1
    ) ELSE IF %%K==%SLOWER_KEY% (
        SET /A SPEED+=1
    )
) 
DEL input.tmp >NUL 2>&1
ECHO %SPEED% >speed.tmp

IF %DIRECTION%==%UP_KEY% (
    SET /A obj_player.ROW-=1
    SET obj_player.ORIGINALSPRITE=spr_man_u
    %render.PlayAnimation% obj_player anim_walk_u
) ELSE IF %DIRECTION%==%DOWN_KEY% (
    SET /A obj_player.ROW+=1
    SET obj_player.ORIGINALSPRITE=spr_man_d
    %render.PlayAnimation% obj_player anim_walk_d
) ELSE IF %DIRECTION%==%LEFT_KEY% (
    SET /A obj_player.COL-=1
    SET obj_player.ORIGINALSPRITE=spr_man_l
    %render.PlayAnimation% obj_player anim_walk_l
) ELSE IF %DIRECTION%==%RIGHT_KEY% (
    SET /A obj_player.COL+=1
    SET obj_player.ORIGINALSPRITE=spr_man_r
    %render.PlayAnimation% obj_player anim_walk_r
) ELSE IF %DIRECTION%==NONE (
    SET obj_player.ANIMATION=
    SET obj_player.SPRITE=%obj_player.ORIGINALSPRITE%
)
    

%render.Animate% OBJS
(@ECHO off & %render.Render% OBJS 0 7 > lines1.tmp) | (@ECHO off & %render.Render% OBJS 8 15 > lines2.tmp) | (@ECHO off & %render.Render% OBJS 16 %RENDERER.HEIGHT% > lines3.tmp)
COPY /B lines*.tmp display.tmp > NUL 2>&1
ECHO                SOUND: %SOUND%   SPEED: %SPEED% >> display.tmp
ECHO 1 > ready.tmp
GOTO :Start