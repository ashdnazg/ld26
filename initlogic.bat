@ECHO off
:Start
SET UP_KEY=1
SET LEFT_KEY=2
SET DOWN_KEY=3
SET RIGHT_KEY=4
SET HIT_KEY=5
SET FASTER_KEY=6
SET SLOWER_KEY=7
SET QUIT_KEY=8
SET INPUTKEY=NONE
SET DIRECTION=NONE
SET HIT_TYPE=NONE
SET SPEED=8
SET LOST=0
SET WORLD_HEIGHT=50
SET WORLD_WIDTH=50


SET MAN_HEIGHT=3
SET MAN_WIDTH=3

DEL *.tmp > NUL 2>&1
ECHO 1 >running.tmp
CALL INCLUDE shrinker

REM %world.CreateWorldSpr% 50 50
REM %render.Object% WORLD WORLD -1 -1
%render.Sprite% spr_ud_wall ud_wall.spr
%render.Sprite% spr_lr_wall lr_wall.spr

%Objects.Object% obj_u_wall1 spr_lr_wall -1 -1 0 0 1 50 -100 KILL
%Objects.Object% obj_d_wall1 spr_lr_wall -1 -1 0 0 1 50 -100 KILL
%Objects.Object% obj_u_wall2 spr_lr_wall -1 -1 0 0 1 50 -100 KILL
%Objects.Object% obj_d_wall2 spr_lr_wall -1 -1 0 0 1 50 -100 KILL
%Objects.Object% obj_l_wall1 spr_ud_wall -1 -1 0 0 50 1 -100 KILL
%Objects.Object% obj_r_wall1 spr_ud_wall -1 -1 0 0 50 1 -100 KILL
%Objects.Object% obj_l_wall2 spr_ud_wall -1 -1 0 0 50 1 -100 KILL
%Objects.Object% obj_r_wall2 spr_ud_wall -1 -1 0 0 50 1 -100 KILL

%render.Sprite% spr_man_d man_d.spr
%render.Sprite% spr_man_r man_r.spr
%render.Sprite% spr_man_l man_l.spr
%render.Sprite% spr_man_u man_u.spr
%Objects.Object% obj_player spr_man_r -200 -200 0 0 3 3 0 STOP
%Objects.Object% obj_npc spr_man_l -200 -200 0 0 3 3 0 STOP VULNERABLE
%render.Animation% anim_man_l_walk man_l_walk1.spr man_l_walk2.spr
%render.Animation% anim_man_r_walk man_r_walk1.spr man_r_walk2.spr
%render.Animation% anim_man_d_walk man_d_walk1.spr man_d.spr man_d_walk3.spr man_d.spr
%render.Animation% anim_man_u_walk man_u_walk1.spr man_u.spr man_u_walk3.spr man_u.spr
%render.Sprite% spr_man_l_kick man_l_kick.spr
%render.Sprite% spr_man_r_kick man_r_kick.spr
%render.Sprite% spr_man_l_punch man_l_punch.spr
%render.Sprite% spr_man_r_punch man_r_punch.spr
%render.Sprite% spr_man_u_punch man_u_punch.spr
%render.Sprite% spr_man_d_punch man_d_punch.spr
%render.Sprite% spr_man_dead dead.spr


%objects.SetRandomLocation% obj_player 0 0 50 50 3 3
%objects.SetRandomLocation% obj_npc 0 0 50 50 3 3

SET /A RENDERER.GLOBAL_ROW=obj_player.ROW - %RENDERER.HEIGHT% / 2
SET /A RENDERER.GLOBAL_COL=obj_player.COL - %RENDERER.WIDTH% / 2