#!/bin/bash -eu

STACK_NAME=MCServerStack

export AWS_DEFAULT_REGION=eu-west-2

echo "Deleting stack"
aws cloudformation delete-stack --stack-name "$STACK_NAME"
aws cloudformation wait stack-delete-complete --stack-name "$STACK_NAME"