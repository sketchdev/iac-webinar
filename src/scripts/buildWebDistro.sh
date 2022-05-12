#!/bin/bash -e

source ./config.sh .
source ./helpers.sh .

export HOSTED_ZONE_ID=${1}
export SOURCE_STAGE=${2}
export SOURCE_BUCKET=${3}
export AWS_STAGE=${4:-Development}
export STACK_METHOD=${5:-create}
export VPC_REGION=${6:-us-east-1}

export STACK_NAME=${PLATFORM_NAME}-FrontEnd-$AWS_STAGE
export AWS_STAGE_LOWER=$(toLower $AWS_STAGE)

# Set up initial CLoudFormation stack
aws cloudformation $STACK_METHOD-stack \
    --region $VPC_REGION \
    --stack-name $STACK_NAME \
    --capabilities CAPABILITY_NAMED_IAM \
    --template-body file://../templates/web-s3.yaml \
    --tags Key=Client,Value=$PLATFORM_NAME Key=Billing,Value=$PLATFORM_NAME \
        Key=Purpose,Value=Web-hosting Key=Environment,Value=$AWS_STAGE \
    --parameters ParameterKey=StageId,ParameterValue=$AWS_STAGE \
        ParameterKey=StageIdLowercase,ParameterValue=$AWS_STAGE_LOWER \
        ParameterKey=SourceStage,ParameterValue=$SOURCE_STAGE \
        ParameterKey=SourceBucket,ParameterValue=$SOURCE_BUCKET \
        ParameterKey=HostedZoneId,ParameterValue=$HOSTED_ZONE_ID \
        ParameterKey=Client,ParameterValue=$PLATFORM_NAME \
        ParameterKey=PlatformName,ParameterValue=$PLATFORM_NAME \
        ParameterKey=PlatformWebDomain,ParameterValue=$PLATFORM_WEB_DOMAIN
