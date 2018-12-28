@echo off&setlocal ENABLEEXTENSIONS

REM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
REM %% CMD line docker runner                    %%
REM %% for Windows systems                       %%
REM %% Author: Tomasz Gorka                      %%
REM %% <tomasz+devnut[at]gorka.org.pl>           %%
REM %% License: MIT 2019                         %%
REM %% Website: https://github.com/tgorka/devnut %%
REM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
SET TEMPLATE_VOLUME=devnut
SET CHECK_UPDATES="1"
REM %%%%%%%%%%%%%%%%%%%%%%%%
REM %%%%% END CUSTOMIZE %%%%
REM %%%%%%%%%%%%%%%%%%%%%%%%
REM another variables
SET USER_NAME=dev
SET VOLUME_EXIST="0"
SET CONTAINER_EXIST="0"
SET COPY_FROM_TEMPLATE="0"

IF %CHECK_UPDATES% == "1" (
       REM make sure to have latest image
       docker pull tgorka/devnut
)

REM exiting running container of "%NAME%" if exist
FOR /F "tokens=*" %%V IN ('docker container ls --format={{.Names}}') DO IF %NAME%==%%V SET CONTAINER_EXIST="1"
IF %CONTAINER_EXIST% == "1" (
       ECHO Container "%NAME%" is running. Killing.
       docker container kill "%NAME%"
)

REM create new volume of "%NAME%" if not exists and copy from the template
FOR /F "tokens=2" %%V IN ('docker volume ls') DO IF %NAME%==%%V SET VOLUME_EXIST="1"
IF %VOLUME_EXIST% == "0" (
       ECHO Volume "%NAME%" does not exist. Creating one.
       docker volume create --name %NAME% --driver local
       SET COPY_FROM_TEMPLATE="1"
)
IF %COPY_FROM_TEMPLATE% == "1" (
       ECHO Copy data from template volume "%TEMPLATE_VOLUME%" to "%NAME%".
       docker run -i -t --rm --privileged ^
              --hostname nut ^
              --mount type=volume,src=%TEMPLATE_VOLUME%,dst=/home/%USER_NAME%/from ^
              --mount type=volume,src=%NAME%,dst=/home/%USER_NAME%/to ^
              --name %NAME%-initialize-volume ^
              tgorka/devnut ^
              sudo rsync --archive /home/%USER_NAME%/from/ /home/%USER_NAME%/to/
       ECHO Setting rights on user "%USER_NAME%" for data in volume "%NAME%".       
       docker run -i -t --rm --privileged ^
              --hostname nut ^
              --mount type=volume,src=%NAME%,dst=/home/%USER_NAME%/data ^
              --name %NAME%-initialize-volume ^
              tgorka/devnut ^
              sudo chown --recursive %USER_NAME% /home/%USER_NAME%/data
)

REM run docker with idea open
docker run -i -t --rm --privileged ^
       --hostname nut ^
       --memory %MEM% ^
       --cpus %CPU% ^
       --mount type=volume,src=%NAME%,dst=/home/%USER_NAME% ^
       --volume %PROVIDER_PATH%:/mnt/host ^
       --name %NAME% ^
       tgorka/devnut ^
       %CMD%
