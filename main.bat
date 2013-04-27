@ECHO off
SETLOCAL DisableDelayedExpansion

CALL INCLUDE text
CALL INCLUDE list
CALL INCLUDE render
CALL INCLUDE timeops

CALL initlogic.bat
(input.bat | logicloop.bat | display.bat) & DEL *.tmp