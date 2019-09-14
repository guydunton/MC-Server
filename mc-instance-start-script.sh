#!/bin/bash -eux
yum update -y
yum install -y java-1.8.0-openjdk

# Create minecraft director
mkdir /minecraft

cd /minecraft
aws s3 cp s3://guydunton-mc-resources/server.jar ./

# Start minecraft to sort out the eula
java -jar server.jar nogui
sed -i 's/eula=false/eula=true/g' eula.txt

# Setup the minecraft service
aws s3 cp s3://guydunton-mc-resources/minecraft.service /etc/systemd/system/minecraft.service
systemctl daemon-reload
systemctl enable minecraft
chown -R ec2-user:ec2-user /minecraft
systemctl start minecraft

