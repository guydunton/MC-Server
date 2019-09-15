#!/bin/bash -eux
yum update -y
yum install -y java-1.8.0-openjdk

# Mount the volume 
if [ $(file -s /dev/xvdh) == "/dev/xvdh: data" ]; then
    mkfs -t ext4 /dev/xvdh
fi

# Create minecraft directory
mkdir /minecraft
mount /dev/xvdh /minecraft/
echo "/dev/xvdh /minecraft ext4 defaults,nofail 0 0" >> /etc/fstab

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

