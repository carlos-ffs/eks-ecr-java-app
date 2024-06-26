eks_managed_node_groups = {
    one = {
      name = "node-group-prd-1"
      instance_types = ["t3.large"]
      min_size     = 3
      max_size     = 6
      desired_size = 3
    }

    two = {
      name = "node-group-prd-2"
      instance_types = ["t3.xlarge"]
      min_size     = 3
      max_size     = 6
      desired_size = 3
    }

    three = {
      name = "node-group-prd-3"
      instance_types = ["t3.2xlarge"]
      min_size     = 3
      max_size     = 6
      desired_size = 3
    }
}

eks_name = "eks-cs-prd"
ecr_name = "ecr-cs-prd"