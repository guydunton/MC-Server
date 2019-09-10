# Minecraft AWS server

These are the resource needed to create a minecraft server on AWS.

## Creating an instance

- Create an instance on EC2 with a user data script containing the contents of `user-data.sh`
- The instance must user a role which gives it access to S3.

## To deploy these resources

**Prerequisites:**

- Have an AWS account with S3 write access setup.

```bash
./deploy.sh
```
