@ECHO off
%render.Animate% OBJS
%render.Render% OBJS 0 %RENDERER.HEIGHT% > display.tmp
:Start
IF NOT EXIST running.tmp EXIT /b
IF EXIST ready.tmp GOTO :Start

SET SOUND=*SILENCE*
SET DIRECTION=NONE
(
    IF EXIST input.tmp FOR /F %%K IN (input.tmp) DO (
        IF %%K LEQ 4 (
            IF %DIRECTION% NEQ %%K (
                SET obj_player.ANIMATION=
                SET DIRECTION=%%K
            ) ELSE REM SET DIRECTION=NONE
        ) ELSE IF %%K==%FASTER_KEY% (
            SET /A SPEED-=1
        ) ELSE IF %%K==%SLOWER_KEY% (
            SET /A SPEED+=1
        )
    )
) >NUL 2>&1 
DEL input.tmp >NUL 2>&1
ECHO %SPEED% >speed.tmp

IF %DIRECTION%==%UP_KEY% (
    SET /A obj_player.ROW-=1
    SET /A RENDERER.GLOBAL_ROW-=1
    SET obj_player.ORIGINALSPRITE=spr_man_u
    %render.PlayAnimation% obj_player anim_walk_u
    SET SOUND=*STEPS*
    %shrinker.Shrink%
) ELSE IF %DIRECTION%==%DOWN_KEY% (
    SET /A obj_player.ROW+=1
    SET /A RENDERER.GLOBAL_ROW+=1
    SET obj_player.ORIGINALSPRITE=spr_man_d
    %render.PlayAnimation% obj_player anim_walk_d
    SET SOUND=*STEPS*
    %shrinker.Shrink%
) ELSE IF %DIRECTION%==%LEFT_KEY% (
    SET /A obj_player.COL-=1
    SET /A RENDERER.GLOBAL_COL-=1
    SET obj_player.ORIGINALSPRITE=spr_man_l
    %render.PlayAnimation% obj_player anim_walk_l
    SET SOUND=*STEPS*
    %shrinker.Shrink%
) ELSE IF %DIRECTION%==%RIGHT_KEY% (
    SET /A obj_player.COL+=1
    SET /A RENDERER.GLOBAL_COL+=1
    SET obj_player.ORIGINALSPRITE=spr_man_r
    %render.PlayAnimation% obj_player anim_walk_r
    SET SOUND=*STEPS*
    %shrinker.Shrink%
) ELSE IF %DIRECTION%==NONE (
    SET obj_player.ANIMATION=
    SET obj_player.PAUSEDANIMATION=
    SET obj_player.SPRITE=%obj_player.ORIGINALSPRITE%
)
IF %obj_ul_corner.ROW% GEQ %obj_player.ROW% SET LOST=1
IF %obj_ul_corner.COL% GEQ %obj_player.COL% SET LOST=1
SET /A player_dr.COL=%obj_player.COL%+2
SET /A player_dr.ROW=%obj_player.ROW%+2
IF %obj_dr_corner.ROW% LEQ %player_dr.ROW% SET LOST=1
IF %obj_dr_corner.COL% LEQ %player_dr.COL% SET LOST=1

IF %LOST%==1 SET SOUND=SQUISH!


%render.Animate% OBJS
(@ECHO off & %render.Render% OBJS 0 6 > lines1.tmp) | (@ECHO off & %render.Render% OBJS 7 13 > lines2.tmp) | (@ECHO off & %render.Render% OBJS 14 %RENDERER.HEIGHT% > lines3.tmp)
COPY /B lines*.tmp display.tmp > NUL 2>&1
ECHO SOUND: %SOUND% >> display.tmp
IF %LOST%==1 (
    ECHO You were killed. Press q to quit. >> display.tmp
    ECHO 04>color.tmp
)
ECHO 1 > ready.tmp
IF %LOST%==0 GOTO :Start