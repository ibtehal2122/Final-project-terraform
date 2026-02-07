output "repository_urls" {
  description = "Map of repository names to their URLs"
  # بيرجع Map: الاسم => اللينك
  value = { for k, v in module.ecr : k => v.repository_url }
}

output "repository_arns" {
  description = "Map of repository names to their ARNs"
  value       = { for k, v in module.ecr : k => v.repository_arn }
}