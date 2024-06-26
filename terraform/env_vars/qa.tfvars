eks_managed_node_groups = {
    one = {
      name = "node-group-qa-1"
      instance_types = ["t3.small"]
      min_size     = 1
      max_size     = 3
      desired_size = 2
    }

    two = {
      name = "node-group-qa-2"
      instance_types = ["t3.small"]
      min_size     = 1
      max_size     = 2
      desired_size = 1
    }
}

eks_name = "eks-cs-qa"
ecr_name = "ecr-cs-qa"