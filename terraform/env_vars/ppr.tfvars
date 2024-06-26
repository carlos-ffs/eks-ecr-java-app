eks_managed_node_groups = {
    one = {
      name = "node-group-prd-1"
      instance_types = ["t3.large"]
      min_size     = 2
      max_size     = 4
      desired_size = 2
    }

    two = {
      name = "node-group-prd-2"
      instance_types = ["t3.2xlarge"]
      min_size     = 2
      max_size     = 4
      desired_size = 2
    }
}

eks_name = "eks-cs-ppr"
ecr_name = "ecr-cs-ppr"