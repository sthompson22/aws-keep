data "aws_eks_cluster_auth" "keep" {
  name = "keep"
}

provider "aws" {
  version                 = "2.61"
  region                  = "ca-central-1"
  shared_credentials_file = "/Users/sthompson22/.aws/credentials"
  profile                 = "sthompson22"
}

provider "kubernetes" {
  version                = "= 1.11.2"
  load_config_file       = false
  host                   = aws_eks_cluster.keep.endpoint
  token                  = data.aws_eks_cluster_auth.keep.token
  cluster_ca_certificate = base64decode(aws_eks_cluster.keep.certificate_authority.0.data)
}

provider "helm" {
  version                = "= 1.2.1"
  repository_config_path = "./config-files/helm-repositories.yaml"

  kubernetes {
    host                   = aws_eks_cluster.keep.endpoint
    token                  = data.aws_eks_cluster_auth.keep.token
    cluster_ca_certificate = base64decode(aws_eks_cluster.keep.certificate_authority.0.data)
  }
}
