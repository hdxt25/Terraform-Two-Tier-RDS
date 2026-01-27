
variable "project_name" {}
variable "aws_region" {}
variable "environment" {}

variable "cidr_block" {}
variable "pub-subnet-count" {}
variable "pri-subnet-count" {}
variable "pub-cidr-block" {
  type = list(string)
}
variable "pri-cidr-block" {
  type = list(string)
}

variable "pub-availability-zone" {
    type = list(string)
}

variable "pri-availability-zone" {
    type = list(string)
}


variable "db_name" {}
variable "db_user" {}

# RDS Module - Variables


variable "db_instance_class" {}
variable "db_allocated_storage" {}
variable "db_engine_version" {}

variable "ec2_instance_type" {}

variable "asg_image_id" {}
variable "asg_instance_type" {}
variable "min_size" {}
variable "max_size" {}
variable "desired_capacity" {}