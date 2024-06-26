terraform {
  required_version = ">= 1.8.1"
  backend "s3" {
    key = "key_will_be_overrided.tfstate"
  }
}

module "module_eks" {
  source = "./modules/eks_module"
  module_eks_cluster_name = var.eks_name
  module_eks_managed_node_groups = var.eks_managed_node_groups
  module_eks_cluster_version = "1.29"
}

module "module_ecr" {
  source = "./modules/ecr_module"
  module_ecr_name = var.ecr_name
}