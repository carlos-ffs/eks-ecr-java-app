variable "region" {
  description = "aws region"
  type        = string
  default = "eu-west-2"
}

variable "module_eks_cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "module_eks_cluster_version" {
  description = "EKS cluster name"
  type        = string
  default = "1.29"
}


variable "module_eks_managed_node_groups" {
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