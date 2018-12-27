@echo off&setlocal ENABLEEXTENSIONS
 
REM change directory if needed
REM C:
chdir %HOMEPATH%

REM set variables
SET NAME=devnut
SET PROVIDER_PATH=%cd%
SET CMD=zsh --login
SET CPU=3.0
SET MEM=4g

REM docker volume create --name %NAME% --driver local

REM run docker with idea open
docker run -i -t --rm --privileged ^
       --hostname nut ^
       --memory %MEM% ^
       --cpus %CPU% ^
       --mount type=volume,src=%NAME%,dst=/home/dev ^
       --volume %PROVIDER_PATH%:/mnt/host ^
       --name %NAME% ^
       tgorka/devnut ^
       %CMD%
