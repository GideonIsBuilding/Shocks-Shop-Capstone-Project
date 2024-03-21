locals {
  owners           = var.business_division
  environment      = var.environment
  name             = "${var.business_division}-${var.environment}"
  eks_cluster_name = "${local.name}-${var.cluster_name}"

  common_tags = {
    owners      = local.owners
    environment = local.environment
  }
}