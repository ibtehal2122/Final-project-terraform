variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_1" {
  description = "CIDR for Public Subnet 1"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_2" {
  description = "CIDR for Public Subnet 2"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_1" {
  description = "CIDR for Private Subnet 1"
  type        = string
  default     = "10.0.3.0/24"
}

variable "private_subnet_2" {
  description = "CIDR for Private Subnet 2"
  type        = string
  default     = "10.0.4.0/24"
}
variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}