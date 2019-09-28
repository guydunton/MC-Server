# Minecraft AWS server

These are the resource needed to create a minecraft server on AWS.

## Creating an instance

To deploy the instance into an AWS account run the following script:

```bash
./deploy-instance.sh
```

**Note**: Requirements to run the instance are listed in `cfn-ec2.yml`

To delete the instance and all associated resources run the following command:

```bash
./teardown-stack.sh
```

The above command will only upload the text resources needed and won't download the minecraft server jar file. To upload the Jar file run the same command with the `--all` flag e.g.

```bash
UPLOAD_ALL=all ./deploy-resources.sh
```

## To deploy these resources

**Prerequisites:**

- Have an AWS account with S3 write access setup.

```bash
./bin/deploy-resources.sh
```

## How to connect to the server

- Open Minecraft Vanilla
- Direct connect to server at <**_public ip address_**>:25565
