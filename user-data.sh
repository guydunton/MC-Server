#!/bin/bash

aws s3 cp s3://guydunton-mc-resources/mc-instance-start-script.sh ./
chmod +x mc-instance-start-script.sh
./mc-instance-start-script.sh