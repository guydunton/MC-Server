#!/bin/bash -eu

if [ $1 == "--all" ]; then
    curl https://launcher.mojang.com/v1/objects/3dc3d84a581f14691199cf6831b71ed1296a9fdf/server.jar > server.jar
    aws s3 mv ./server.jar s3://guydunton-mc-resources/
fi

aws s3 cp ./server-resources/mc-instance-start-script.sh s3://guydunton-mc-resources/
aws s3 cp ./server-resources/minecraft.service s3://guydunton-mc-resources/