@ECHO off
SETLOCAL EnableDelayedExpansion
%objects.Sort%
%render.Animate% OBJECTS_LIST
%render.Render% OBJECTS_LIST 0 %RENDERER.HEIGHT% > display.tmp
:Start
IF NOT EXIST running.tmp EXIT /b
IF EXIST ready.tmp GOTO :Start
SET SOUND=*SILENCE*
SET COLLISION=0
REM %shrinker.Shrink%
REM SET DIRECTION=NONE
(
    IF EXIST input.tmp FOR /F %%K IN (input.tmp) DO (
        IF %%K LEQ 5 (
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
) >NUL 2>&1 
DEL input.tmp >NUL 2>&1
ECHO %SPEED% >speed.tmp

IF %DIRECTION%==%UP_KEY% (
    SET /A obj_player.ROW-=1
    %objects.CheckMove% obj_player COLLISION
    IF !COLLISION!==STOP (
        SET /A obj_player.ROW+=1
        SET DIRECTION=NONE
    ) ELSE (
        SET /A RENDERER.GLOBAL_ROW-=1
        SET obj_player.ORIGINALSPRITE=spr_man_u
        %render.PlayAnimation% obj_player anim_man_u_walk
        SET SOUND=*STEPS*
        SET OBJECTS_LIST.CHANGED=1
    )
) ELSE IF %DIRECTION%==%DOWN_KEY% (
    SET /A obj_player.ROW+=1
    %objects.CheckMove% obj_player COLLISION
    IF !COLLISION!==STOP (
        SET /A obj_player.ROW-=1
        SET DIRECTION=NONE
    ) ELSE (
        SET /A RENDERER.GLOBAL_ROW+=1
        SET obj_player.ORIGINALSPRITE=spr_man_d
        %render.PlayAnimation% obj_player anim_man_d_walk
        SET SOUND=*STEPS*
        SET OBJECTS_LIST.CHANGED=1
    )
) ELSE IF %DIRECTION%==%LEFT_KEY% (
    SET /A obj_player.COL-=1
    %objects.CheckMove% obj_player COLLISION
    ECHO !COLLISION! >> text.text
    IF !COLLISION!==STOP (
        SET /A obj_player.COL+=1
        SET DIRECTION=NONE
    ) ELSE (
        SET /A RENDERER.GLOBAL_COL-=1
        SET obj_player.ORIGINALSPRITE=spr_man_l
        %render.PlayAnimation% obj_player anim_man_l_walk
        SET SOUND=*STEPS*
    )
) ELSE IF %DIRECTION%==%RIGHT_KEY% (
    SET /A obj_player.COL+=1
    %objects.CheckMove% obj_player COLLISION
    IF !COLLISION!==STOP (
        SET /A obj_player.COL-=1
        SET DIRECTION=NONE
    ) ELSE (
        SET /A RENDERER.GLOBAL_COL+=1
        SET obj_player.ORIGINALSPRITE=spr_man_r
        %render.PlayAnimation% obj_player anim_man_r_walk
        SET SOUND=*STEPS*
    )
) ELSE IF %DIRECTION%==%HIT_KEY% (
    IF "%obj_player.SPRITE:~8,1%"=="r" (
        SET /A HIT_TYPE=%RANDOM% %% 2
        SET /A obj_player.COL+=HIT_TYPE
        SET /A RENDERER.GLOBAL_COL+=HIT_TYPE
    ) ELSE IF "%obj_player.SPRITE:~8,1%"=="l" (
        SET /A HIT_TYPE+=%RANDOM% %% 2
        SET /A obj_player.COL-=HIT_TYPE
        SET /A RENDERER.GLOBAL_COL-=HIT_TYPE
    ) ELSE SET HIT_TYPE=1
    SET SOUND=POW!
)
IF %DIRECTION%==NONE (
    SET obj_player.ANIMATION=
    SET obj_player.PAUSEDANIMATION=
    SET obj_player.SPRITE=%obj_player.ORIGINALSPRITE%
    IF !COLLISION!==0 %objects.CheckMove% obj_player COLLISION
)
IF !COLLISION!==KILL SET LOST=1
IF %HIT_TYPE%==0 (
    SET obj_player.SPRITE=%obj_player.ORIGINALSPRITE:~0,9%_kick
) ELSE IF %HIT_TYPE%==1 (
    SET obj_player.SPRITE=%obj_player.ORIGINALSPRITE:~0,9%_punch
)
SET HIT_TYPE=NONE
REM IF %obj_ul_corner.ROW% GEQ %obj_player.ROW% SET LOST=1
REM IF %obj_ul_corner.COL% GEQ %obj_player.COL% SET LOST=1
REM SET /A player_dr.COL=%obj_player.COL%+2
REM SET /A player_dr.ROW=%obj_player.ROW%+2
REM IF %obj_dr_corner.ROW% LEQ %player_dr.ROW% SET LOST=1
REM IF %obj_dr_corner.COL% LEQ %player_dr.COL% SET LOST=1
SET SOUND=POW!
SET > bla.txt
IF %LOST%==1 SET SOUND=SQUISH!
%objects.Sort% OBJECTS_LIST
%render.Animate% OBJECTS_LIST
(@ECHO off & %render.Render% OBJECTS_LIST 0 6 > lines1.tmp) | (@ECHO off & %render.Render% OBJECTS_LIST 7 13 > lines2.tmp) | (@ECHO off & %render.Render% OBJECTS_LIST 14 %RENDERER.HEIGHT% > lines3.tmp)
COPY /B lines*.tmp display.tmp > NUL 2>&1
ECHO SOUND: %SOUND% >> display.tmp
IF %LOST%==1 (
    ECHO You were killed. Press q to quit. >> display.tmp
    ECHO 04>color.tmp
)
ECHO 1 > ready.tmp
IF %LOST%==0 GOTO :Start