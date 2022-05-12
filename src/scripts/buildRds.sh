#!/bin/bash -e

source ./config.sh .
source ./helpers.sh .

export AWS_STAGE=${1:-Development}
export SNAPSHOT_ID=${2:-''}
export STACK_METHOD=${3:-create}
export VPC_REGION=${4:-us-east-1}

export STACK_NAME=${PLATFORM_NAME}-Rds-$AWS_STAGE
export AWS_STAGE_LOWER=$(toLower $AWS_STAGE)
export PLATFORM_NAME_LOWER=$(toLower $PLATFORM_NAME)
export AZ_COUNT=$(aws ec2 describe-availability-zones --region $VPC_REGION --filters Name=state,Values=available --out text --query "AvailabilityZones[*].ZoneName" | wc -w | sed -e 's/ //g')

# Set up initial CLoudFormation stack
aws cloudformation $STACK_METHOD-stack \
    --region $VPC_REGION \
    --stack-name $STACK_NAME \
    --template-body file://../templates/rdsTemplate.yaml \
    --tags Key=Client,Value=$PLATFORM_NAME Key=Billing,Value=$PLATFORM_NAME \
        Key=Purpose,Value=Database Key=Environment,Value=$AWS_STAGE \
    --parameters ParameterKey=StageId,ParameterValue=$AWS_STAGE \
        ParameterKey=StageIdLowercase,ParameterValue=$AWS_STAGE_LOWER \
        ParameterKey=Client,ParameterValue=$PLATFORM_NAME \
        ParameterKey=PlatformName,ParameterValue=$PLATFORM_NAME \
        ParameterKey=PlatformNameLowercase,ParameterValue=$PLATFORM_NAME_LOWER \
        ParameterKey=AZCount,ParameterValue=$AZ_COUNT \
        ParameterKey=DBSnapshotArn,ParameterValue=$SNAPSHOT_ID
