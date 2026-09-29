data "tls_certificate" "eks" {
  url = aws_eks_cluster.wanderlust-cluster.identity[0].oidc[0].issuer
}


resource "aws_key_pair" "eks_nodegroup_key" {
  key_name   = "eks-nodegroup-key"
  public_key = file("${path.module}/wanderlust-key.pub")
}

resource "aws_iam_role" "eks_cluster_role" {
  name = "wanderlust-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "eks.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role" "eks_node_role" {
  name = "wanderlust-eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]

  url = aws_eks_cluster.wanderlust-cluster.identity[0].oidc[0].issuer
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "eks_container_registry_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPullOnly"
}

resource "aws_eks_access_entry" "master" {
  cluster_name  = aws_eks_cluster.wanderlust-cluster.name
  principal_arn = aws_iam_role.master_role.arn
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "master_admin" {
  cluster_name  = aws_eks_cluster.wanderlust-cluster.name
  principal_arn = aws_iam_role.master_role.arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }

  depends_on = [aws_eks_access_entry.master]
}

resource "aws_eks_cluster" "wanderlust-cluster" {
  name     = "wanderlust-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = "1.36"

  vpc_config {
    subnet_ids = module.vpc.private_subnets
  }

  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
  }



  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]
}

resource "aws_eks_node_group" "wanderlust-eks-node" {
  cluster_name    = aws_eks_cluster.wanderlust-cluster.name
  node_group_name = "wanderlust"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = module.vpc.private_subnets

  instance_types = ["c7i-flex.large"]



  remote_access {
    ec2_ssh_key = aws_key_pair.eks_nodegroup_key.key_name
  }

  scaling_config {
    desired_size = 2
    min_size     = 2
    max_size     = 2
  }

  disk_size = 20

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.eks_container_registry_policy
  ]

  tags = {
    Name        = "node-group"
    Environment = "development"
  }
}
