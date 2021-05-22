resource "aws_eks_node_group" "eks" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = var.eks_cluster_workernode_name
  node_role_arn   = aws_iam_role.eks-worker-nodes.arn
  subnet_ids      = ["subnet-xxxx", "subnet-xxx"]

  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-AmazonEC2ContainerRegistryReadOnly,
  ]
}

resource "aws_eks_node_group" "eks-worker" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = var.eks_cluster_workernode_jenkins_name
  node_role_arn   = aws_iam_role.eks-worker-nodes.arn
  subnet_ids      = ["subnet-xxxx", "subnet-xxxx"]

  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 1
  }
  instance_types = ["m5.large", "m5d.large", "m4.large","t3.large","t3a.large","m5a.large","t2.large"] 
  capacity_type = "SPOT"
  labels = {
    lifecycle = "EC2SPOT"
    intent = "jenkins-agents"
  }
  tags = {
    Name = "ec2spot-jenkins-slave"
    lifecycle = "EC2SPOT"
    intent = "jenkins-agents"
    spot = "true"
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-AmazonEC2ContainerRegistryReadOnly,
  ]
}

resource "aws_iam_role" "eks-worker-nodes" {
  name = var.eks_cluster_worker_iam_role

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

resource "aws_iam_role_policy_attachment" "eks-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks-worker-nodes.name
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks-worker-nodes.name
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-worker-nodes.name
}
