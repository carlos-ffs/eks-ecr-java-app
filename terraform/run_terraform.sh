#!/bin/bash
set -e
set -o pipefail

echo

echodate() {
    echo
    echo $(tput setaf 15)$(date +%Y-%m-%d) $(date +%H:%M:%S) $* $(tput setaf 7)
}

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

# Check if working directory, terraform action and environment are provided as arguments
usage () {
      echo "Please provide an $(tput setaf 3)action$(tput setaf 7) and $(tput setaf 3)environment$(tput setaf 7) as arguments"
      echo
      echo $(tput setaf 3)'./run_terraform.sh <plan, apply or destroy> <dev, tst, qa, ppr, prd>'
      echo $(tput setaf 7)
      exit
}

case $1 in

  "plan" | "apply" | "destroy")
    TERRAFORM_ACTION=${1}
    ;;

  *)
    usage
    ;;
esac

case $2 in

  "dev" | "tst" | "qa" | "ppr" | "prd" )
    TERRAFORM_ENVIRONMENT=${2}
    ;;

  *)
    usage
    ;;
esac


WORKING_DIRECTORY=.


# Remove local temporary terraform files if previous execution failed abruptly.
rm -rf ${WORKING_DIRECTORY}/.terraform* && rm -rf ${WORKING_DIRECTORY}/.state.conf


shift
shift


echo "key=\"terraform_${TERRAFORM_ENVIRONMENT}.tfstate\"" > "${WORKING_DIRECTORY}/.state.conf"


# Created function just to organize code.
s3_bucket_info () {
    # Search for bucket that contains "statesf-cs" in the name. For the task the default S3 bucket name is: tf-statesf-cs  
    BUCKET_NAME=$(aws s3api list-buckets --query "Buckets[?contains(Name, 'statesf-cs')].Name" --output text)

    # Check if a bucket name was found
    if [ -z "$BUCKET_NAME" ]; then
    echo "No bucket found containing 'states' in its name."
    exit 1
    fi

    # Get the region of the bucket
    BUCKET_REGION=$(aws s3api get-bucket-location --bucket "$BUCKET_NAME" --query "LocationConstraint" --output text)

    if [ "$BUCKET_REGION" == "None" ] || [ -z "$BUCKET_REGION" ]; then
      BUCKET_REGION="eu-west-2" # sets default to eu-west-2 (london)
    fi
}

s3_bucket_info

# Initialize working directory with backend configuration
echodate "Initialize working directory with backend configuration - terraform init"
time terraform -chdir=${WORKING_DIRECTORY} \
      init \
      -backend-config="bucket=${BUCKET_NAME}" \
      -backend-config="region=${BUCKET_REGION}" \
      -backend-config=".state.conf"


# Validate the working directory configuration
echodate "Validate the working directory configuration - terraform validate"
terraform -chdir=${WORKING_DIRECTORY} \
      validate

# Decide the terraform action to execute
if [ "${TERRAFORM_ACTION}" == "plan" ]
then
      # Create the execution plan
      echodate "Create the execution plan - terraform plan"
      terraform -chdir=${WORKING_DIRECTORY} \
            plan \
            -var-file="./env_vars/${TERRAFORM_ENVIRONMENT}.tfvars" \
            
elif [ "${TERRAFORM_ACTION}" == "apply" ] 
then

      echodate "Apply changes - terraform apply"
      terraform -chdir=${WORKING_DIRECTORY} \
            apply \
            -auto-approve \
            -var-file="./env_vars/${TERRAFORM_ENVIRONMENT}.tfvars" \
            
elif [ "${TERRAFORM_ACTION}" == "destroy" ] 
then
      echodate "Destroy changes - terraform destroy"
      terraform -chdir=${WORKING_DIRECTORY} \
            destroy \
            -auto-approve \
            -var-file="./env_vars/${TERRAFORM_ENVIRONMENT}.tfvars" \

fi

echodate "$(tput setaf 2)Done!"$(tput setaf 7)
echo

# Remove local temporary terraform files
rm -rf ${WORKING_DIRECTORY}/.terraform* && rm -rf ${WORKING_DIRECTORY}/.state.conf