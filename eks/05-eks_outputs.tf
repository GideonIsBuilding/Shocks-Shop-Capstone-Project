output "cluster_id" {
  value       = aws_eks_cluster.eks_cluster.id
}

output "cluster_arn" {
  value       = aws_eks_cluster.eks_cluster.arn
}

output "cluster_certificate_authority_data" {
  value       = aws_eks_cluster.eks_cluster.certificate_authority[0].data
}

output "cluster_endpoint" {
  value       = aws_eks_cluster.eks_cluster.endpoint
}

output "cluster_version" {
  value       = aws_eks_cluster.eks_cluster.version
}

output "cluster_iam_role_name" {
  value       = aws_iam_role.eks_master_role.name
}

output "cluster_iam_role_arn" {
  value       = aws_iam_role.eks_master_role.arn
}

output "cluster_oidc_issuer_url" {
  value       = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}

output "cluster_primary_security_group_id" {
  value       = aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id
}

output "node_group_public_id" {
  value       = aws_eks_node_group.eks_ng_public.id
}

output "node_group_public_arn" {
  value       = aws_eks_node_group.eks_ng_public.arn
}

output "node_group_public_status" {
  value       = aws_eks_node_group.eks_ng_public.status
}

output "node_group_public_version" {
  value       = aws_eks_node_group.eks_ng_public.version
}
