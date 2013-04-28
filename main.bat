@ECHO off
SETLOCAL EnableDelayedExpansion
ECHO Loading Libraries...
CALL INCLUDE text
CALL INCLUDE render
CALL INCLUDE objects

CALL initlogic.bat
CLS
TYPE intro.scr
PAUSE > NUL


(input.bat | logicloop.bat | display.bat) & DEL *.tmp & color 07
REM input.bat | logicloop.bat