#!/bin/bash -eu
cd /minecraft
ls | grep -v server.jar | xargs | xargs -I {} sh -c 'tar -czvf ~/world.tar.gz {}';
aws s3 cp ~/world.tar.gz s3://guydunton-mc-world-data-bucket