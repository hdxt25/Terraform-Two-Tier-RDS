# VPC Module - Variables

variable "project_name" {}

variable "environment" {}

variable "cidr_block" {}
variable "pub-subnet-count" {}
variable "pri-subnet-count" {}

variable "pub-availability-zone" {
    type = list(string)
}

variable "pri-availability-zone" {
    type = list(string)
}

variable "pub-cidr-block" {
  type = list(string)
}

variable "pri-cidr-block" {
  type = list(string)
}