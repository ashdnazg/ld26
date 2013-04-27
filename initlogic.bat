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
SET SPEED=7
DEL *.tmp > NUL 2>&1
ECHO 1 >running.tmp

%render.Sprite% spr_man_d man_d.spr
%render.Sprite% spr_man_r man_r.spr
%render.Sprite% spr_man_l man_l.spr
%render.Sprite% spr_man_u man_u.spr
%render.Object% obj_player spr_man_d 10 10
%render.Animation% anim_walk_l man_l_walk1.spr man_l_walk2.spr
%render.Animation% anim_walk_r man_r_walk1.spr man_r_walk2.spr
%render.Animation% anim_walk_d man_d_walk1.spr man_d.spr man_d_walk3.spr man_d.spr
%render.Animation% anim_walk_u man_u_walk1.spr man_u.spr man_u_walk3.spr man_u.spr
%@list.GetAll% RENDERER.OBJECTS OBJS