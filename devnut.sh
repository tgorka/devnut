#!/bin/bash

# change directory if needed
#cd ~\devnut

# run docker compose
# docker-compose up

# Create local volume before running the container
# docker volume create --name devnut --driver local

# run docker with idea open
docker run -i -t --rm --privileged \
       --memory 4g \
       --cpus 3.0 \
       --mount type=volume,src=devnut,dst=/home/dev \
       --volume $(pwd):/mnt/host \
       --name devnut \
       tgorka/devnut \
       zsh
