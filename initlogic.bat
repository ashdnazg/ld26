@ECHO off
:Start
SET UP_KEY=1
SET LEFT_KEY=2
SET DOWN_KEY=3
SET RIGHT_KEY=4
SET QUIT_KEY=5
SET FASTER_KEY=6
SET SLOWER_KEY=7
SET INPUTKEY=NONE
SET DIRECTION=NONE
SET SPEED=8
SET LOST=0
DEL *.tmp > NUL 2>&1
ECHO 1 >running.tmp
CALL INCLUDE shrinker

REM %world.CreateWorldSpr% 50 50
REM %render.Object% WORLD WORLD -1 -1
%render.Sprite% spr_ud_wall ud_wall.spr
%render.Sprite% spr_lr_wall lr_wall.spr
%render.Sprite% spr_corner corner.spr
%render.Object% obj_u_wall spr_lr_wall -1 -1
%render.Object% obj_l_wall spr_ud_wall -1 -1
%render.Object% obj_d_wall spr_lr_wall 50 -1
%render.Object% obj_r_wall spr_ud_wall -1 50
%render.Object% obj_ul_corner spr_corner -1 -1
%render.Object% obj_ur_corner spr_corner -1 50
%render.Object% obj_dl_corner spr_corner 50 -1
%render.Object% obj_dr_corner spr_corner 50 50


%render.Sprite% spr_man_d man_d.spr
%render.Sprite% spr_man_r man_r.spr
%render.Sprite% spr_man_l man_l.spr
%render.Sprite% spr_man_u man_u.spr
%render.Object% obj_player spr_man_d 24 24
%render.Animation% anim_walk_l man_l_walk1.spr man_l_walk2.spr
%render.Animation% anim_walk_r man_r_walk1.spr man_r_walk2.spr
%render.Animation% anim_walk_d man_d_walk1.spr man_d.spr man_d_walk3.spr man_d.spr
%render.Animation% anim_walk_u man_u_walk1.spr man_u.spr man_u_walk3.spr man_u.spr
%@list.GetAll% RENDERER.OBJECTS OBJS