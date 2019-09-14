#!/bin/bash -eu

STACK_NAME=MCServerStack

aws cloudformation deploy \
    --template-file cfn-ec2.yml \
    --stack-name "$STACK_NAME"

INSTANCE_IP=$(aws cloudformation describe-stacks \
    --stack-name "$STACK_NAME" \
    --query "Stacks[*].Outputs[?OutputKey=='InstanceIP'].OutputValue" \
    --output text)

echo "IP:"
echo "$INSTANCE_IP:25565"