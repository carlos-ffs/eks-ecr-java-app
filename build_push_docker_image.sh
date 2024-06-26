#!/bin/bash
set -e
set -o pipefail

echo

# Check if service principal id and secret variables are exported
if [ -z "$AWS_ACCESS_KEY_ID" ]  || [ -z "$AWS_SECRET_ACCESS_KEY" ]
then
      echo
      echo "Please export $(tput setaf 3)AWS_ACCESS_KEY_ID $(tput setaf 7)and $(tput setaf 3)AWS_SECRET_ACCESS_KEY $(tput setaf 7)variables"
      echo
      echo $(tput setaf 3)'set +o history;'
      echo $(tput setaf 3)'export AWS_ACCESS_KEY_ID="<id>";'
      echo $(tput setaf 3)'export AWS_SECRET_ACCESS_KEY="<secret>"'
      echo $(tput setaf 3)'set -o history'
      echo $(tput setaf 7)
      exit
fi

echodate() {
    echo
    echo $(tput setaf 15)$(date +%Y-%m-%d) $(date +%H:%M:%S) $* $(tput setaf 7)
}


usage () {
      echo "Please provide the $(tput setaf 3)ECR URL$(tput setaf 7) and the $(tput setaf 3)docker image tag $(tput setaf 7) as arguments"
      echo
      echo $(tput setaf 3)'./build_push_docker_image.sh <ECR URL> <DOCKER IMAGE TAG>'
      echo $(tput setaf 3)'Example: ./build_push_docker_image.sh 905418004582.dkr.ecr.eu-west-2.amazonaws.com/ecr-cs-dev clock-api-2.0.0'
      echo $(tput setaf 7)
      exit
}

if [ $# -lt 2 ]; then
    usage
    exit 1
fi

ECR_URL=$1
DOCKER_IMAGE_TAG=$2

shift
shift


ECR_URL_ROOT=$(echo $ECR_URL | cut -d'/' -f1)
aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin $ECR_URL_ROOT

# Necessary because my macbook is arm64 based, and the t2 instances are amd64.
docker build --platform linux/amd64 -t $ECR_URL:$DOCKER_IMAGE_TAG ./world-clock/.
echodate "$(tput setaf 2)Docker build finished!"$(tput setaf 7)
echo

docker push $ECR_URL:$DOCKER_IMAGE_TAG
echodate "$(tput setaf 2)Docker push completed!"$(tput setaf 7)
echo