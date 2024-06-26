# Assignment to create an EKS, ECR repository, and deploy a Java web application with a helm chart to the newly created EKS using the ECR repository

This assignment as the following Objectives:

1. Create a web application in Java that handles HTTP requests.
    - Set up two routes on port 8080 :
        - GET /: Should return the current local time for New York, Berlin, and Tokyo, formatted in HTML.
        - GET /health: This should return a JSON response with an HTTP status code of 200 to indicate the application's health.

2. Containerize the java application.

3. Use Terraform to define and create the necessary cloud infrastructure:
    - Virtual Private Cloud (VPC)
    - Subnets, security groups, routing tables, etc
    - EKS cluster
    - ECR repository for storing the app's container image.
4. Develop a Helm chart for the java application to facilitate its deployment on the EKS cluster.
5. Configure the necessary resources to ensure the application can be accessed externally.
6. A publicly accessible URL to access the world clock app.



## Steps to execute the assignment solution

1. Export the assignment directory and the AWS Access credentials.
    
    ```bash
    export ASSIGNMENT_HOME=<Path to Assignment directory>/.
    export AWS_ACCESS_KEY_ID="<KEY>"
    export AWS_SECRET_ACCESS_KEY="<SECRET>"
    ```
    Note: Terraform is using a S3 bucket as backend to store the state files.

2. Run terraform script to deploy the new EKS and ECR.

    ```bash
    cd $ASSIGNMENT_HOME/terraform
    ./run_terraform.sh apply dev
    ```
3. **Get the ECR URI value** from the AWS Management Console or by running the following command:
    
    ```bash
    aws ecr describe-repositories --repository-names ecr-cs-dev --region eu-west-2 --output json | jq -r '.repositories[0].repositoryUri'

    # Example output:
    # 905418004582.dkr.ecr.eu-west-2.amazonaws.com/ecr-cs-dev
    ```
4. Build and push the docker image to the newly created ECR repository.

    ```bash
    cd $ASSIGNMENT_HOME
    
    # Syntax: ./build_push_docker_image.sh <ECR URI> <DOCKER IMAGE TAG>
    
    ./build_push_docker_image.sh 905418004582.dkr.ecr.eu-west-2.amazonaws.com/ecr-cs-dev clock-api-2.0.0
    ```
5. Deploy the World Clock helm chart into the new EKS.
    
    ```bash
    cd $ASSIGNMENT_HOME
    
    # Syntax: ./deploy_world_clock.sh <ECR URL> <DOCKER IMAGE TAG> <EKS NAME> <EKS REGION> <PATH TO KUBECONFIG FILE> <K8S NAMESPACE TO DEPLOY WORLD CLOCK> <WORLD CLOCK API KEY> <WORLD CLOCK API SECRET>

    ./deploy_world_clock.sh 905418004582.dkr.ecr.eu-west-2.amazonaws.com/ecr-cs-dev clock-api-2.0.0 eks-cs-dev eu-west-2 ./dev-kubeconfig world-clock-ns admin admin
    ```