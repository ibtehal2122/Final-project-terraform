output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "List of Public Subnet IDs"
  value = [
    aws_subnet.public_1.id,
    aws_subnet.public_2.id
  ]
}

output "private_subnet_ids" {
  description = "List of Private Subnet IDs"
  value = [
    aws_subnet.private_1.id,
    aws_subnet.private_2.id
  ]
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

# التعديل هنا: شلنا [*] وخليناها قيمة واحدة مباشرة
output "nat_gateway_id" {
  description = "The ID of the Single NAT Gateway"
  value       = aws_nat_gateway.nat.id
}