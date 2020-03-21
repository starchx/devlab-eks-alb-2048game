#!/bin/bash

STACK_NAME=devlab-eks-alb-2048game

echo; echo "Creating Cloud 9 Environment"

aws cloudformation deploy --template-file cloud9.yaml --capabilities CAPABILITY_IAM --stack-name $STACK_NAME

ADMIN_ROLE=$(aws cloudformation describe-stacks --stack-name $STACK_NAME --query "Stacks[0].Outputs[?OutputKey=='InstanceProfile'].OutputValue" --output text)
CLOUD9_ENVIRONMENT_ID=$(aws cloudformation describe-stacks --stack-name $STACK_NAME --query "Stacks[0].Outputs[?OutputKey=='Cloud9EnvironmentId'].OutputValue" --output text)
CLOUD9_INSTANCE_ID=$(aws ec2 describe-instances --filters "Name=tag:aws:cloud9:environment,Values=$CLOUD9_ENVIRONMENT_ID" --query "Reservations[0].Instances[0].InstanceId" --output text)

echo; echo "Assign Cloud 9 Instance Role: $ADMIN_ROLE"

aws ec2 associate-iam-instance-profile --iam-instance-profile Name=$ADMIN_ROLE --instance-id $CLOUD9_INSTANCE_ID

echo; echo "Ready to continue the next step."
