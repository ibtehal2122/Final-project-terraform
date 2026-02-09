variable "project_name" {
  default = "ebtehal-final-eks"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {
    Project     = "ebtehal-final-eks"
    ManagedBy   = "terraform"
    Environment = "production"
  }
}

variable "my_ip" {
  description = "My public IP address to access EKS API"
  type        = string
  default     = "197.49.180.62" # استبدلي هذا بـ الـ IP بتاعك
}