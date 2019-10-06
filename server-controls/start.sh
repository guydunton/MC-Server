#!/bin/bash -eu

INSTANCE_ID=$(aws cloudformation describe-stack-resources \
    --stack-name MCServerStack \
    --query "StackResources[?ResourceType=='AWS::EC2::Instance'].PhysicalResourceId" \
    --output text)

aws ec2 start-instances --instance-ids "$INSTANCE_ID"