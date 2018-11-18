@echo off&setlocal ENABLEEXTENSIONS

REM change directory if needed
REM C:
REM chdir %HOMEPATH%\OneDrive\devnut\test

REM run docker compose
REM docker-compose up

REM run docker with idea open
docker run -i -t --rm ^
       -m 4g ^
       -v %HOMEPATH%\devnut\x11:/tmp/.X11-unix ^
       -v %HOMEPATH%\devnut:/home/nut ^
       --name devnut-test ^
       tgorka/devnut ^
       bash
