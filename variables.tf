variable "region" {
  description = "The target region"
  default = "us-east-1"
}

variable "eks_cluster_name" {
  description = "cluster name"
  default = "ops"
}

variable "eks_cluster_subnets" {
  description = "cluster subnets"
  type = list(string)
  default = ["subnet-xxx", "subnet-xxx"]
}

variable "eks_cluster_iam_role" {
  description = "cluster role name"
  default = "eks-cluster-role-ops"
}

variable "eks_cluster_workernode_name" {
  description = "workernode name"
  default = "eks-workernodes-ops"

variable "eks_cluster_workernode_jenkins_name" {
  description = "workernode name"
  default = "eks-workernodes-ops-jenkins-spot"
}
variable "eks_cluster_worker_iam_role" {
  description = "cluster role name"
  default = "eks-node-group-ops"
}
