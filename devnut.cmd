@echo off&setlocal ENABLEEXTENSIONS

REM change directory if needed
REM C:
REM chdir %HOMEPATH%\devnut

REM run docker compose
REM docker-compose up

REM Create local volume before running the container
REM docker volume create --name devnut --driver local

REM run docker with idea open
docker run -i -t --rm --privileged ^
       --memory 4g ^
       --cpus 3.0 ^
       --mount type=volume,src=devnut,dst=/home/dev ^
       --name devnut ^
       tgorka/devnut ^
       zsh