# RDS Module - Variables

variable "project_name" {}

variable "environment" {}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for DB subnet group"
  type        = list(string)
}

variable "db_security_group_id" {}

variable "db_name" {}

variable "db_user" {}


variable "db_password" {}
variable "db_instance_class" {}

variable "db_allocated_storage" {}

variable "db_engine_version" {}