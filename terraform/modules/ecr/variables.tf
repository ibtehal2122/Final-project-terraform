variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
}