resource "aws_iam_role" "eks_cluster" {
  name = "${var.project_name}-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# ---------------- EKS CLUSTER ----------------
resource "aws_eks_cluster" "eks" {
  name     = var.project_name
  role_arn = aws_iam_role.eks_cluster.arn
  version  = "1.29"

  vpc_config {
    subnet_ids              = var.private_subnets
    endpoint_public_access  = true
    endpoint_private_access = true 
    # public_access_cidrs     = [var.my_ip] # هنا التعديل السحري
  }
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]
}
