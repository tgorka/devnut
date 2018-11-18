@echo off&setlocal ENABLEEXTENSIONS

REM change directory if needed
C:
chdir %HOMEPATH%\devnut

REM run docker compose
REM docker-compose up

REM run docker with idea open
docker -it --rm ^
       -m 4g ^
       -v ./.X11-unix:/tmp/.X11-unix ^
       -v .:/home/nut ^
       -name devnut ^
       tgorka/devnut ^
       idea
