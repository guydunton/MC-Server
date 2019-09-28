#!/bin/bash -eu

STACK_NAME=MCServerStack
WORLD_DATA_BUCKET_NAME=guydunton-mc-world-data

export AWS_DEFAULT_REGION=eu-west-2

# If it doesn't exist create a world data bucket 
if [[ $(aws s3api head-bucket --bucket "$WORLD_DATA_BUCKET_NAME" 2>&1) != "" ]]; then
    aws s3 mb s3://guydunton-mc-world-data
    aws s3api put-bucket-versioning \
        --bucket "$WORLD_DATA_BUCKET_NAME" \
        --versioning-configuration Status=Enabled

    aws s3api put-bucket-lifecycle-configuration \
        --bucket "$WORLD_DATA_BUCKET_NAME" \
        --lifecycle-configuration file://lifecycle.json

fi

aws cloudformation deploy \
    --template-file cfn-ec2.yml \
    --capabilities CAPABILITY_NAMED_IAM \
    --stack-name "$STACK_NAME" \
    --parameter-overrides \
        AmiId=ami-00a1270ce1e007c27 \
        SshKeyName=MCInstanceAccess \
        WorldBucketName="$WORLD_DATA_BUCKET_NAME"

INSTANCE_IP=$(aws cloudformation describe-stacks \
    --stack-name "$STACK_NAME" \
    --query "Stacks[*].Outputs[?OutputKey=='InstanceIP'].OutputValue" \
    --output text)

echo "IP:"
echo "$INSTANCE_IP:25565"