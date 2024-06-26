eks_managed_node_groups = {
    one = {
      name = "node-group-dev-1"
      instance_types = ["t3.small"]
      min_size     = 1
      max_size     = 3
      desired_size = 1
    }

    two = {
      name = "node-group-dev-2"
      instance_types = ["t3.small"]
      min_size     = 1
      max_size     = 2
      desired_size = 1
    }
}

eks_name = "eks-cs-dev"

ecr_name = "ecr-cs-dev"