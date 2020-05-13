# cluster
## IAM role
resource "aws_iam_role" "keep-eks-cluster" {
  name               = "keep-eks-cluster"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.keep-eks-cluster.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.keep-eks-cluster.name
}

resource "aws_kms_key" "keep-eks-cluster" {
  description             = "This key is used to encrypt bucket objects."
  deletion_window_in_days = 10
}

resource "aws_kms_alias" "keep-eks-cluster" {
  name          = "alias/keep-eks-cluster"
  target_key_id = aws_kms_key.keep-eks-cluster.id
}

## cluster definiton
resource "aws_eks_cluster" "keep" {
  name     = "keep"
  role_arn = aws_iam_role.keep-eks-cluster.arn
  version  = "1.16"

  vpc_config {
    subnet_ids = [
      aws_subnet.public-ca-central-1a.id,
      aws_subnet.public-ca-central-1b.id,
      aws_subnet.public-ca-central-1d.id,
      aws_subnet.private-ca-central-1a.id,
      aws_subnet.private-ca-central-1b.id,
      aws_subnet.public-ca-central-1d.id
    ]
    endpoint_private_access = true
    endpoint_public_access  = false
  }

  encryption_config {

    provider {
      key_arn = aws_kms_key.keep-eks-cluster.arn
    }

    resources = [
      "secrets",
    ]
  }

  tags = {
    Name        = "keep"
    Environment = "keep"
    Region      = "ca-central-1"
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy,
  ]
}

# node group
## IAM role
resource "aws_iam_role" "keep-node-group" {
  name               = "keep-node-group"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.keep-node-group.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.keep-node-group.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.keep-node-group.name
}

resource "aws_iam_role_policy_attachment" "CloudWatchAgentServerPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.keep-node-group.name
}

## group definition
resource "aws_eks_node_group" "keep-node-group" {
  cluster_name    = aws_eks_cluster.keep.name
  node_group_name = "keep"
  node_role_arn   = aws_iam_role.keep-node-group.arn
  subnet_ids      = [aws_subnet.private-ca-central-1b.id, aws_subnet.private-ca-central-1d.id]
  ami_type        = "AL2_x86_64"
  instance_types  = ["t3.medium"]
  disk_size       = "20"

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 2
  }

  tags = {
    Name        = "keep-node-group"
    Environment = "keep"
    Region      = "ca-central-1"
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}
