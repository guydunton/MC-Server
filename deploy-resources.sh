#!/bin/bash -eu

UPLOAD=${UPLOAD_ALL:-}

if [[ $UPLOAD == "all" ]]; then
    curl https://launcher.mojang.com/v1/objects/3dc3d84a581f14691199cf6831b71ed1296a9fdf/server.jar > server.jar
    aws s3 mv ./server.jar s3://guydunton-mc-resources/
fi

aws s3 cp server-resources s3://guydunton-mc-resources --recursive