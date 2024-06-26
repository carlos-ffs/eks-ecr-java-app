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
      echo "Please provide the $(tput setaf 3)ECR URL$(tput setaf 7), $(tput setaf 3)docker image tag $(tput setaf 7), $(tput setaf 3)EKS name$(tput setaf 7), $(tput setaf 3)EKS REGION$(tput setaf 7), $(tput setaf 3)path to the kubeconfig file$(tput setaf 7), $(tput setaf 3)k8s namespace to deploy the world clock app$(tput setaf 7), $(tput setaf 3)world clock api key value$(tput setaf 7), and the $(tput setaf 3)world clock api secret value$(tput setaf 7)  as arguments"
      echo
      echo $(tput setaf 3)'./deploy_world_clock.sh <ECR URL> <DOCKER IMAGE TAG> <EKS NAME> <EKS REGION> <PATH TO KUBECONFIG FILE> <K8S NAMESPACE TO DEPLOY WORLD CLOCK> <WORLD CLOCK API KEY> <WORLD CLOCK API SECRET>'
      echo $(tput setaf 3)'Example: ./deploy_world_clock.sh 905418004582.dkr.ecr.eu-west-2.amazonaws.com/ecr-cs-dev clock-api-2.0.0 eks-cs-dev eu-west-2 ./dev-kubeconfig world-clock-ns admin admin'
      echo $(tput setaf 7)
      exit
}

if [ $# -lt 8 ]; then
    usage
    exit 1
fi

ECR_URL=$1
DOCKER_IMAGE_TAG=$2
EKS_NAME=$3
EKS_REGION=$4
KUBECONFIG_PATH=$5
NAMESPACE=$6
WC_API_KEY=$7
WC_API_SECRET=$8

rm -rf $KUBECONFIG_PATH

aws eks --region $EKS_REGION update-kubeconfig --name $EKS_NAME --kubeconfig "$KUBECONFIG_PATH"

ECR_URL_ROOT=$(echo $ECR_URL | cut -d'/' -f1)

kubectl create namespace "$NAMESPACE" --dry-run=client -o yaml --kubeconfig "$KUBECONFIG_PATH" | kubectl apply --kubeconfig "$KUBECONFIG_PATH" -f -

kubectl create secret docker-registry ecr-registry-creds \
    --docker-server="$ECR_URL_ROOT" \
    --docker-username=AWS \
    --docker-password=$(aws ecr get-login-password) \
    --namespace=$NAMESPACE --kubeconfig "$KUBECONFIG_PATH" --dry-run=client -o yaml | kubectl apply --kubeconfig "$KUBECONFIG_PATH" -f -

kubectl create secret generic world-clock-creds \
    --from-literal=API_KEY="$WC_API_KEY" --from-literal=API_SECRET="$WC_API_SECRET" \
    --namespace=$NAMESPACE --kubeconfig "$KUBECONFIG_PATH" --dry-run=client -o yaml | kubectl apply --kubeconfig "$KUBECONFIG_PATH" -f -

WC_CREDS_ENC=$(echo -n "$WC_API_KEY:$WC_API_SECRET" | base64)

helm upgrade --install --atomic world-timer "./world-clock-chart" \
    --set image.repository="$ECR_URL" \
    --set image.tag="$DOCKER_IMAGE_TAG" \
    --set worldClockCredentials.secretRef="world-clock-creds" \
    --set imagePullSecrets[0].name=ecr-registry-creds \
    --set "livenessProbe.httpGet.httpHeaders[0].name=Authorization" \
    --set "readinessProbe.httpGet.httpHeaders[0].name=Authorization" \
    --set "livenessProbe.httpGet.httpHeaders[0].value=Basic $WC_CREDS_ENC" \
    --set "readinessProbe.httpGet.httpHeaders[0].value=Basic $WC_CREDS_ENC" \
    --namespace=$NAMESPACE --kubeconfig "$KUBECONFIG_PATH"

rm -rf $KUBECONFIG_PATH