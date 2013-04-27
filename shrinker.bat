::@ECHO off
:Start
CALL :%*
EXIT /b
:Init
SET SHRINKER.UP=0
SET SHRINKER.DOWN=1
SET SHRINKER.LEFT=2
SET SHRINKER.RIGHT=3

EXIT /b

:Shrink
SET /A SHRINKER.SHRINKDIR=%RANDOM% %% 4
IF %SHRINKER.SHRINKDIR%==%SHRINKER.UP% (
    SET /A obj_u_wall.ROW+=1
    SET /A obj_ul_corner.ROW+=1
    SET /A obj_ur_corner.ROW+=1
) ELSE IF %SHRINKER.SHRINKDIR%==%SHRINKER.DOWN% (
    SET /A obj_d_wall.ROW-=1
    SET /A obj_dl_corner.ROW-=1
    SET /A obj_dr_corner.ROW-=1
) ELSE IF %SHRINKER.SHRINKDIR%==%SHRINKER.LEFT% (
    SET /A obj_l_wall.COL+=1
    SET /A obj_dl_corner.COL+=1
    SET /A obj_ul_corner.COL+=1
) ELSE IF %SHRINKER.SHRINKDIR%==%SHRINKER.RIGHT% (
    SET /A obj_r_wall.COL-=1
    SET /A obj_dr_corner.COL-=1
    SET /A obj_ur_corner.COL-=1
)
EXIT /b