#!/bin/bash -eux
yum update -y
yum install -y java-1.8.0-openjdk

# If not formatted, format the volume
IS_VOLUME_FORMATTED=$(file -s /dev/xvdh)
if [ "$IS_VOLUME_FORMATTED" == "/dev/xvdh: data" ]; then
    mkfs -t ext4 /dev/xvdh
fi

# Create minecraft directory
mkdir /minecraft
mount /dev/xvdh /minecraft/
echo "/dev/xvdh /minecraft ext4 defaults,nofail 0 0" >> /etc/fstab

# Setup the server backup script (& add into cron)
aws s3 cp s3://guydunton-mc-resources/world-backup.sh /home/ec2-user/world-backup.sh
chmod +x /home/ec2-user/world-backup.sh
crontab -u ec2-user <(echo "0 * * * * /home/ec2-user/world-backup.sh")

# Add the server jar to /minecraft
cd /minecraft
aws s3 cp s3://guydunton-mc-resources/server.jar ./

# If the world data exists pull it from S3
if aws s3 ls s3://guydunton-mc-world-data-bucket/world.tar.gz; then
    pushd /minecraft
    aws s3 cp s3://guydunton-mc-world-data-bucket/world.tar.gz ./
    tar -zxvf /minecraft/world.tar.gz
    popd
else
    # Start minecraft to sort out the eula
    java -jar server.jar nogui
    sed -i 's/eula=false/eula=true/g' eula.txt
fi

# Setup the minecraft service
aws s3 cp s3://guydunton-mc-resources/minecraft.service /etc/systemd/system/minecraft.service
systemctl daemon-reload
systemctl enable minecraft
chown -R ec2-user:ec2-user /minecraft
systemctl start minecraft

