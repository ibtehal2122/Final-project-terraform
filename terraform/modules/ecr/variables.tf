variable "repository_names" {
  description = "List of repository names"
  type        = list(string)
  default     = ["backend", "frontend"]
}

variable "tags" {
  type    = map(string)
  default = {}
}