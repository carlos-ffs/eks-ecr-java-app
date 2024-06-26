variable "aws_s3_bucket_tf_states_region" {
  description = "S3 terraform state files bucket region"
  type        = string
  default = "eu-west-2"
}

variable "aws_s3_bucket_tf_states_name" {
  description = "S3 terraform state files bucket name"
  type        = string
  default = "tf-statesf-cs"
}

variable "eks_managed_node_groups" {
  description = "A map of EKS managed node groups configurations"
  type = map(object({
    name          = string
    instance_types = list(string)
    min_size      = number
    max_size      = number
    desired_size  = number
  }))

  default = {
    one = {
      name = "node-group-1"
      instance_types = ["t3.small"]
      min_size     = 1
      max_size     = 3
      desired_size = 2
    }

    two = {
      name = "node-group-2"
      instance_types = ["t3.small"]
      min_size     = 1
      max_size     = 2
      desired_size = 1
    }
  }
}

variable "eks_name" {
  description = "EKS name"
  type        = string
  default = "eks-cs"
}

variable "ecr_name" {
  description = "ECR name"
  type        = string
  default = "ecr-cs"
}
