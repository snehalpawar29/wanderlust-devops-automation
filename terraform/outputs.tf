output "region" {
  description = "Region"
  value       = local.region
}

output "vpc_id" {
  description = "The ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.master.public_ip
}

output "eks_cluster_name" {
  value = aws_eks_cluster.wanderlust-cluster.name
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.wanderlust-cluster.endpoint
}

output "eks_node_group_name" {
  value = aws_eks_node_group.wanderlust-eks-node.node_group_name
}

# output "eks_nodes_public_ip" {
#   value = aws_in
# }
output "eks_oidc_issuer" {
  value = aws_eks_cluster.wanderlust-cluster.identity[0].oidc[0].issuer
}

output "jenkins_worker_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.jenkins-worker.public_ip
}
