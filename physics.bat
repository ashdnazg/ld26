::@ECHO off
:Start
CALL :%*
EXIT /b
:Init
%list.New% PHYSICS.BY_ROW
%list.New% PHYSICS.BY_COL
EXIT /b

:Object <out_object> <top_row> <left_col> <bottom_row> <right_col>
SET %~1.DELTA.TOP_ROW=%~2
SET %~1.DELTA.LEFT_COL=%~3
SET %~1.DELTA.BOTTOM_ROW=%~4
SET %~1.DELTA.RIGHT_COL=%~5
Exit /b

:CheckCollision
Exit /b

:GetRandomLocation <out_x> <out_y>
SET /A %~1=%RANDOM% %% (%WORLD_SIZE_ROWS% - 10) + 4
SET /A %~2=%RANDOM% %% (%WORLD_SIZE_COLS% - 10) + 4

EXIT /b

