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
SET HIT_TYPE=NONE
REM %shrinker.Shrink%
IF %DIRECTION%==%HIT_KEY% SET DIRECTION=NONE
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
ECHO Before moving: %TIME% >> time.txt
IF %DIRECTION%==%UP_KEY% (
    SET /A obj_player.ROW-=1
    %objects.CheckMove% obj_player STOP COLLISION
    ECHO After checking: !TIME! >> time.txt
    IF !COLLISION! NEQ NONE (
        SET /A obj_player.ROW+=1
        SET DIRECTION=NONE
    ) ELSE (
        SET /A RENDERER.GLOBAL_ROW-=1
        REM SET obj_player.ORIGINALSPRITE=spr_man_u
        %render.PlayAnimation% obj_player anim_man_%obj_player.ORIGINALSPRITE:~-1%_walk
        SET SOUND=*STEPS*
        SET OBJECTS_LIST.CHANGED=1
    )
) ELSE IF %DIRECTION%==%DOWN_KEY% (
    SET /A obj_player.ROW+=1
    %objects.CheckMove% obj_player STOP COLLISION
    IF !COLLISION! NEQ NONE (
        SET /A obj_player.ROW-=1
        SET DIRECTION=NONE
    ) ELSE (
        SET /A RENDERER.GLOBAL_ROW+=1
        REM SET obj_player.ORIGINALSPRITE=spr_man_d
        %render.PlayAnimation% obj_player anim_man_%obj_player.ORIGINALSPRITE:~-1%_walk
        SET SOUND=*STEPS*
        SET OBJECTS_LIST.CHANGED=1
    )
) ELSE IF %DIRECTION%==%LEFT_KEY% (
    SET /A obj_player.COL-=1
    %objects.CheckMove% obj_player STOP COLLISION
    IF !COLLISION! NEQ NONE (
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
    %objects.CheckMove% obj_player STOP COLLISION
    IF !COLLISION! NEQ NONE (
        SET /A obj_player.COL-=1
        SET DIRECTION=NONE
    ) ELSE (
        SET /A RENDERER.GLOBAL_COL+=1
        SET obj_player.ORIGINALSPRITE=spr_man_r
        %render.PlayAnimation% obj_player anim_man_r_walk
        SET SOUND=*STEPS*
    )
) ELSE IF %DIRECTION%==%HIT_KEY% (
    IF "%obj_player.ORIGINALSPRITE:~8,1%"=="r" (
        SET /A HIT_TYPE=%RANDOM% %% 2
        SET /A obj_player.COL+=1
        %objects.CheckMove% obj_player STOP COLLISION
        IF !COLLISION! NEQ NONE (
            %objects.CheckMove% obj_player VULNERABLE COLLISION
            SET /A !COLLISION!.COL+=1
            SET COLLISION=NONE
        )
        IF !COLLISION!==NONE (
            SET /A obj_player.COL+=HIT_TYPE-1
            SET /A RENDERER.GLOBAL_COL+=HIT_TYPE
        )
        
    ) ELSE IF "%obj_player.ORIGINALSPRITE:~8,1%"=="l" (
        SET /A HIT_TYPE+=%RANDOM% %% 2
        SET /A obj_player.COL-=1
        %objects.CheckMove% obj_player STOP COLLISION
         IF !COLLISION! NEQ NONE (
            %objects.CheckMove% obj_player VULNERABLE COLLISION
            SET /A !COLLISION!.COL-=1
            SET COLLISION=NONE
        )
        IF !COLLISION!==NONE (
            SET /A obj_player.COL-=HIT_TYPE-1
            SET /A RENDERER.GLOBAL_COL-=HIT_TYPE
        )
    ) ELSE SET HIT_TYPE=1
    SET SOUND=POW!

)

ECHO After moves: %TIME% >> time.txt
IF %DIRECTION%==NONE (
    SET obj_player.ANIMATION=
    SET obj_player.PAUSEDANIMATION=
    SET obj_player.SPRITE=%obj_player.ORIGINALSPRITE%
)
FOR %%V IN (%VULNERABLE_LIST%) DO (
    %objects.CheckMove% %%V KILL COLLISION
    IF !COLLISION! NEQ NONE (
        SET %%V.ANIMATION=
        SET %%V.PAUSEDANIMATION=
        SET %%V.SPRITE=spr_man_dead
        SET /A %%V.ROW+=2
        SET VULNERABLE_LIST=!VULNERABLE_LIST:%%V=!
        SET STOP_LIST=!VULNERABLE_LIST:%%V,=!
    )
)
%objects.CheckMove% obj_player KILL COLLISION
IF !COLLISION! NEQ NONE SET LOST=1
IF %HIT_TYPE%==0 (
    SET obj_player.SPRITE=%obj_player.ORIGINALSPRITE:~0,9%_kick
) ELSE IF %HIT_TYPE%==1 (
    SET obj_player.SPRITE=%obj_player.ORIGINALSPRITE:~0,9%_punch
)

SET SOUND=POW!
IF %LOST%==1 SET SOUND=SQUISH!
ECHO Before sort and animation: %TIME% >> time.txt
%objects.Sort% OBJECTS_LIST
%render.Animate% OBJECTS_LIST
ECHO Before Render: %TIME% >> time.txt
(@ECHO off & %render.Render% OBJECTS_LIST 0 6 > lines1.tmp) | (@ECHO off & %render.Render% OBJECTS_LIST 7 13 > lines2.tmp) | (@ECHO off & %render.Render% OBJECTS_LIST 14 %RENDERER.HEIGHT% > lines3.tmp)
ECHO After Render: %TIME% >> time.txt
COPY /B lines*.tmp display.tmp > NUL 2>&1
ECHO SOUND: %SOUND% >> display.tmp
IF %LOST%==1 (
    ECHO You were killed. Press q to quit. >> display.tmp
    ECHO 04>color.tmp
)
ECHO 1 > ready.tmp
IF %LOST%==0 GOTO :Start