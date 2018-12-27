@echo off&setlocal ENABLEEXTENSIONS

REM change directory for binding into the docker /mnt/host
chdir %HOMEPATH%

REM %%%%%%%%%%%%%%%%%%%%%%%%
REM %%%%% TO CUSTOMIZE %%%%%
REM %%%%% set variables %%%%
REM %%%%%%%%%%%%%%%%%%%%%%%%
SET NAME=devnut
SET PROVIDER_PATH=%cd%
SET CMD=zsh --login
SET CPU=3.0
SET MEM=4g
REM %%%%%%%%%%%%%%%%%%%%%%%%
REM %%%%% END CUSTOMIZE %%%%
REM %%%%%%%%%%%%%%%%%%%%%%%%

REM create new volume if not exists
REM powershell -command "(docker volume ls | findstr %NAME% | Measure-Object -line).lines"
SET VOLUME_EXIST="0"
FOR /f "tokens=2" %%V IN ('docker volume ls') DO IF %NAME%==%%V SET VOLUME_EXIST="1"
IF %VOLUME_EXIST%=="0" (
       ECHO Volume "%NAME%" does not exist. Creating one.
       docker volume create --name %NAME% --driver local
)

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
