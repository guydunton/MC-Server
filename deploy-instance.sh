#!/bin/bash -eu

STACK_NAME=MCServerStack

export AWS_DEFAULT_REGION=eu-west-2

# If it doesn't exist create a bucket 

aws cloudformation deploy \
    --template-file cfn-ec2.yml \
    --capabilities CAPABILITY_NAMED_IAM \
    --stack-name "$STACK_NAME" \
    --parameter-overrides AmiId=ami-00a1270ce1e007c27 SshKeyName=MCInstanceAccess

INSTANCE_IP=$(aws cloudformation describe-stacks \
    --stack-name "$STACK_NAME" \
    --query "Stacks[*].Outputs[?OutputKey=='InstanceIP'].OutputValue" \
    --output text)

echo "IP:"
echo "$INSTANCE_IP:25565"