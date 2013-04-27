::@ECHO off

:Start
CALL %~1 Init
SET "include.LIBNAME=%~1"

FOR /F %%A IN (%~1.bat) DO (
    CALL :ProcessLine "%%A"
)
GOTO :EOF

:ProcessLine
SET "include.processline.LINE=%~1"
IF "%include.processline.LINE:~,1%"==":" (
    IF "%include.processline.LINE:~1,1%" NEQ ":" (
        CALL SET "%include.LIBNAME%.%include.processline.LINE:~1%=CALL %include.LIBNAME% %include.processline.LINE:~1%"
    )
)
GOTO :EOF
