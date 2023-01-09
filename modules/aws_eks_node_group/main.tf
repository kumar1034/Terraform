resource "aws_eks_node_group" "eks_group" {
  cluster_name    = var.eks_cluster_name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.iam_node_group_role.arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

instance_types = ["t3.medium"]

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks-group-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-group-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-group-AmazonEC2ContainerRegistryReadOnly,
  ]

  tags = var.tags
}


resource "aws_iam_role" "iam_node_group_role" {
  name = var.node_iam_role

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "eks-group-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.iam_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "eks-group-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.iam_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "eks-group-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.iam_node_group_role.name
}