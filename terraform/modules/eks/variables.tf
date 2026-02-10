variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "private_subnet_ids" {
  description = "The IDs of the private subnets"
  type        = list(string)
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "kubernetes_version" {
  description = "The version of Kubernetes to use"
  type        = string
  default     = "1.29"
}

variable "enable_public_access" {
  description = "Whether to enable public access to the EKS cluster endpoint"
  type        = bool
  default     = false
}

variable "public_access_cidrs" {
  description = "The CIDR blocks that are allowed to access the EKS public endpoint"
  type        = list(string)
  default     = []
}

variable "ssh_key_name" {
  description = "The name of the SSH key to use for the nodes"
  type        = string
  default     = null
}

variable "node_groups" {
  description = "A map of EKS node groups to create"
  type        = any
  default     = {}
}

variable "common_tags" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
  default     = {}
}
