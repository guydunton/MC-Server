#!/bin/bash -eu

STACK_NAME=MCServerStack

export AWS_DEFAULT_REGION=eu-west-2

# Clean up the world data bucket
echo "Cleaning bucket"
aws s3 rm s3://guydunton-mc-world-data-bucket --recursive

echo "Deleting stack"
aws cloudformation delete-stack --stack-name "$STACK_NAME"
aws cloudformation wait stack-delete-complete --stack-name "$STACK_NAME"