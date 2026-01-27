# VPC Module - Outputs

output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.vpc.id
}

output "public_subnet_ids" {
  description = "ID of the public subnet"
  value       = [aws_subnet.public-subnet[0].id, aws_subnet.public-subnet[1].id]
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = [aws_subnet.private-subnet[0].id, aws_subnet.private-subnet[1].id]
}

output "vpc_cidr" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.vpc.cidr_block
}

# Security Groups Module - Outputs

output "ec2_sg_id" {
  description = "ID of the ec2 server security group"
  value       = aws_security_group.ec2_sg.id
}

output "db_sg_id" {
  description = "ID of the database security group"
  value       = aws_security_group.db_sg.id
}

output "alb_sg_id" {
  description = "ID of the application load balancer security group"
  value       = aws_security_group.alb_sg.id
}