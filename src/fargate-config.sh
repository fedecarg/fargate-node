#!/bin/bash

#===============================================================================
# Web application
#===============================================================================

# Application name
APP_NAME="node-webapp"

# Environment to pass to the container
APP_ENV="${APP_ENV:-dev}"

# Port number on the container that is bound to the app
APP_PORT="${APP_PORT:-3000}"

# Absolute path to the app (and Dockerfile)
APP_PATH=$(cd $(dirname "$0")/../node-webapp-example; pwd)


#===============================================================================
# Git
#===============================================================================

# Git release branch name (defaults to current branch)
GIT_RELEASE_BRANCH=$(git branch | grep \* | cut -d ' ' -f2)

# Set current git branch
GIT_CURRENT_BRANCH=$(git branch | grep \* | cut -d ' ' -f2)

# Git revision SHA1 hash
GIT_REVISION=$(git rev-parse "${GIT_CURRENT_BRANCH}")

# Git username to associate release with an identity
GIT_USER=$(git config --global user.name)

# Absolute path of the top-level directory
GIT_TOP_LEVEL_DIR=$(git rev-parse --show-toplevel)


#===============================================================================
# AWS
#===============================================================================

# Account ID number on the AWS Management Console
AWS_ACCOUNT_ID="123456789"

# Named profile defined in ~/.aws/config
AWS_DEFAULT_PROFILE="${APP_NAME}"

# Region defined in ~/.aws/config
AWS_REGION=$(aws configure get ${AWS_DEFAULT_PROFILE}.region)


#===============================================================================
# Amazon Elastic Container Service (ECS)
#===============================================================================

# ECS cluster name where tasks or services are grouped
ECS_CLUSTER_NAME="${APP_NAME}-${APP_ENV}"

# A task definition is required to run Docker containers in ECS
ECS_TASK_NAME="${ECS_CLUSTER_NAME}-task"

# A service name is required to know which task definition to use
ECS_SERVICE_NAME="${ECS_CLUSTER_NAME}-service"

# CPU: 512  - Memory: 1024
# CPU: 1024 - Memory: 2048
ECS_CPU="1024"
ECS_MEMORY="2048"


#===============================================================================
# Amazon Elastic Container Registry (ECR)
#===============================================================================

# Name of the repository
ECR_NAME="${APP_NAME}-repository"

# URI of the repository
ECR_URI="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

# The tag of the Docker image
ECR_TAG="${GIT_REVISION:-latest}"

# The Docker image we want to deploy
ECR_IMAGE="${ECR_URI}/${ECR_NAME}:${ECR_TAG}"

# Name of the Docker container
ECR_CONTAINER_NAME="${APP_NAME}-container"


#===============================================================================
# Amazon Elastic Load Balancer (ELB)
#===============================================================================

# The name of the load balancer
ELB_NAME="${ECS_CLUSTER_NAME}-elb"

# The Amazon Resource Name (ARN) of the LBC target group associated with the service
ELB_TARGET_GROUP_ARN="arn:aws:elasticloadbalancing:${AWS_REGION}:${AWS_ACCOUNT_ID}:targetgroup/http-ip-target/fcd686125971656c"

#EOF