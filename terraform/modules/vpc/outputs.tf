output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.this.id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = concat([aws_subnet.public.id], aws_subnet.public_2[*].id)
}