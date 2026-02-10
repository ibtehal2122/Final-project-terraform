variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "num_public_subnets" {
  description = "The number of public subnets to create"
  type        = number
  default     = 2
}

variable "num_private_subnets" {
  description = "The number of private subnets to create"
  type        = number
  default     = 2
}

variable "num_nat_gateways" {
  description = "The number of NAT gateways to create"
  type        = number
  default     = 2
}

variable "common_tags" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
  default     = {}
}
