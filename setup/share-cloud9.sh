#!/bin/bash

## If AWS CLI user is not same as AWS Console user, the Cloud 9 can't be used by AWS Console user until the Cloud 9 environment is shared.
## Speicify ARN of AWS Console User ARN in variable $AWS_CONSOLE_USER_ARN and run this script to share the environment.

AWS_CONSOLE_USER_ARN=<AWS CONSOLE LOGIN ARN>

STACK_NAME=devlab-eks-alb-2048game

CLOUD9_ENVIRONMENT_ID=$(aws cloudformation describe-stacks --stack-name $STACK_NAME --query "Stacks[0].Outputs[?OutputKey=='Cloud9EnvironmentId'].OutputValue" --output text)

echo; echo "Share Cloud 9 Environment to AWS Console User"

aws cloud9 create-environment-membership --environment-id $CLOUD9_ENVIRONMENT_ID --user-arn $AWS_CONSOLE_USER_ARN --permissions read-write
