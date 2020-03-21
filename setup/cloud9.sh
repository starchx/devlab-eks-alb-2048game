#!/bin/bash

## Warning - If AWS CLI user is not same as AWS Console user, the Cloud 9 can't be used by AWS Console user until it is shared.
## AWS Console User ARN to be specified in $AWS_CONSOLE_USER_ARN

AWS_CONSOLE_USER_ARN=<AWS CONSOLE LOGIN ARN>

STACK_NAME=devlab-eks-alb-2048game

echo; echo "Creating Cloud 9 Environment"

aws cloudformation deploy --template-file cloud9.yaml --capabilities CAPABILITY_IAM --stack-name $STACK_NAME

ADMIN_ROLE=$(aws cloudformation describe-stacks --stack-name $STACK_NAME --query "Stacks[0].Outputs[?OutputKey=='InstanceProfile'].OutputValue" --output text)
CLOUD9_ENVIRONMENT_ID=$(aws cloudformation describe-stacks --stack-name $STACK_NAME --query "Stacks[0].Outputs[?OutputKey=='Cloud9EnvironmentId'].OutputValue" --output text)
CLOUD9_INSTANCE_ID=$(aws ec2 describe-instances --filters "Name=tag:aws:cloud9:environment,Values=$CLOUD9_ENVIRONMENT_ID" --query "Reservations[0].Instances[0].InstanceId" --output text)

echo; echo "Assign Cloud 9 Instance Role: $ADMIN_ROLE"

aws ec2 associate-iam-instance-profile --iam-instance-profile Name=$ADMIN_ROLE --instance-id $CLOUD9_INSTANCE_ID

echo; echo "Share Cloud 9 Environment to AWS Console User"

aws cloud9 create-environment-membership --environment-id $CLOUD9_ENVIRONMENT_ID --user-arn $AWS_CONSOLE_USER_ARN --permissions read-write
