@ECHO off
SETLOCAL EnableDelayedExpansion

CALL INCLUDE text
CALL INCLUDE list
CALL INCLUDE render
CALL INCLUDE timeops
CALL INCLUDE objects

CALL initlogic.bat
(input.bat | logicloop.bat | display.bat) & DEL *.tmp
REM input.bat | logicloop.bat