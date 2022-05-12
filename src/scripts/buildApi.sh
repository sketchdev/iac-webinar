#!/bin/bash

source ./config.sh .
source ./helpers.sh .

export AWS_STAGE=${1:-Development}
export HOSTED_ZONE_ID=${2:-''}
export SOURCE_STAGE_ID=${3:-''}
export APP_VERSION=${4:-''}
export STACK_METHOD=${5:-create}
export VPC_REGION=${6:-us-east-1}

export STACK_NAME=${PLATFORM_NAME}-Api-$AWS_STAGE
export AWS_STAGE_LOWER=$(toLower $AWS_STAGE)
export PLATFORM_NAME_LOWER=$(toLower $PLATFORM_NAME)
export SOURCE_STAGE_ID_LOWERCASE=$(toLower $SOURCE_STAGE_ID)

# Set up initial CLoudFormation stack
aws cloudformation $STACK_METHOD-stack \
    --region $VPC_REGION \
    --stack-name $STACK_NAME \
    --template-body file://../templates/beanstalk.yaml \
    --capabilities CAPABILITY_NAMED_IAM \
    --tags Key=Client,Value=$PLATFORM_NAME Key=Billing,Value=$PLATFORM_NAME \
        Key=Purpose,Value=Database Key=Environment,Value=$AWS_STAGE \
    --parameters ParameterKey=StageId,ParameterValue=$AWS_STAGE \
        ParameterKey=StageIdLowercase,ParameterValue=$AWS_STAGE_LOWER \
        ParameterKey=Client,ParameterValue=$PLATFORM_NAME \
        ParameterKey=PlatformName,ParameterValue=$PLATFORM_NAME \
        ParameterKey=PlatformNameLowercase,ParameterValue=$PLATFORM_NAME_LOWER \
        ParameterKey=PlatformDomain,ParameterValue=$PLATFORM_WEB_DOMAIN \
        ParameterKey=HostedZoneId,ParameterValue=$HOSTED_ZONE_ID \
        ParameterKey=SourceStageIdLowercase,ParameterValue=$SOURCE_STAGE_ID_LOWERCASE \
        ParameterKey=AppVersion,ParameterValue=$APP_VERSION \
