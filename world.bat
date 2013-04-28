::@ECHO off
:Start
CALL :%*
EXIT /b
:Init
EXIT /b

:UpdateWorld <height> <width>
IF %obj_player.COL%==%UPDATE_COL_u_1% (
    SET /A ROW=obj_wall_u_section1.ROW-1 
    SET /A COL=obj_wall_u_section1.COL + spr_wall_u_section1[0].LEN + 1
    CALL :Section 2 u !ROW! !COL!
    SET /A obj_sep_u.ROW=obj_wall_u_section1.ROW
    SET /A obj_sep_u.COL=COL-1
    SET UPDATE_COL_u_1=NONE
)
IF %obj_player.COL%==%UPDATE_COL_u_2% (
    SET /A ROW=obj_wall_u_section2.ROW-1 
    SET /A COL=obj_wall_u_section2.COL + spr_wall_u_section2[0].LEN + 1
    CALL :Section 1 u !ROW! !COL!
    SET /A obj_sep_u.ROW=obj_wall_u_section2.ROW
    SET /A obj_sep_u.COL=COL-1
    SET UPDATE_COL_u_2=NONE
)
IF %obj_player.COL%==%UPDATE_COL_d_1% (
    SET /A ROW=obj_wall_d_section1.ROW+1 
    SET /A COL=obj_wall_d_section1.COL + spr_wall_d_section1[0].LEN + 1
    CALL :Section 2 d !ROW! !COL!
    SET /A obj_sep_d.ROW=obj_wall_d_section1.ROW
    SET /A obj_sep_d.COL=COL-1
    SET UPDATE_COL_d_1=NONE
)
IF %obj_player.COL%==%UPDATE_COL_d_2% (
    SET /A ROW=obj_wall_d_section2.ROW+1 
    SET /A COL=obj_wall_d_section2.COL + spr_wall_d_section2[0].LEN + 1
    CALL :Section 1 d !ROW! !COL!
    SET /A obj_sep_d.ROW=obj_wall_d_section2.ROW
    SET /A obj_sep_d.COL=COL-1
    SET UPDATE_COL_d_2=NONE
)
IF %RANDOM% LEQ 300 (
    SET /A obj_wall_u_section1.ROW+=1
    SET /A obj_wall_u_section2.ROW+=1
    SET /A obj_sep_u.ROW+=1
    SET /A obj_wall_d_section1.ROW-=1
    SET /A obj_wall_d_section2.ROW-=1
    SET /A obj_sep_d.ROW-=1
)
IF %RANDOM% LEQ 2000 (
    IF %obj_npc1.COL% LEQ %RENDERER.GLOBAL_COL% (
        SET /A COL=%obj_player.COL% + 70
        %objects.SetRandomLocation% obj_npc1 %obj_wall_u_section1.ROW% !COL! %obj_wall_d_section1.ROW% !COL! 3 3
        %render.PlayAnimation% obj_npc1 anim_man_l_walk
        SET VULNERABLE_LIST=!VULNERABLE_LIST:obj_npc1=!,obj_npc1
        SET STOP_LIST=!STOP_LIST:obj_npc1=!,obj_npc1
        SET obj_npc1.HP=7
    ) ELSE IF %obj_npc2.COL% LEQ %RENDERER.GLOBAL_COL% (
        SET /A COL=%obj_player.COL% + 70
        %objects.SetRandomLocation% obj_npc2 %obj_wall_u_section1.ROW% !COL! %obj_wall_d_section1.ROW% !COL! 3 3
        %render.PlayAnimation% obj_npc2 anim_man_l_walk
        SET VULNERABLE_LIST=!VULNERABLE_LIST:obj_npc2=!,obj_npc2
        SET STOP_LIST=!STOP_LIST:obj_npc2=!,obj_npc2
        SET obj_npc2.HP=7
    ) ELSE IF %obj_npc3.COL% LEQ %RENDERER.GLOBAL_COL% (
        SET /A COL=%obj_player.COL% + 70
        %objects.SetRandomLocation% obj_npc3 %obj_wall_u_section1.ROW% !COL! %obj_wall_d_section1.ROW% !COL! 3 3
        %render.PlayAnimation% obj_npc3 anim_man_l_walk
        SET VULNERABLE_LIST=!VULNERABLE_LIST:obj_npc3=!,obj_npc3
        SET STOP_LIST=!STOP_LIST:obj_npc3=!,obj_npc3
        SET obj_npc3.HP=7
    )
)
EXIT /b

:Section <num> <dir> <row> <col>
SET /A LEN=%RANDOM% %% 50 + 75 
SET obj_wall_%~2_section%~1.ROW=%~3
SET obj_wall_%~2_section%~1.COL=%~4
SET spr_wall_%~2_section%~1[0].LEN=%LEN%
SET obj_wall_%~2_section%~1.DELTA.RIGHT_COL=%LEN%
SET /A UPDATE_COL_%~2_%~1=%~4 + %LEN% / 2
EXIT /b

:Shrink
EXIT /b