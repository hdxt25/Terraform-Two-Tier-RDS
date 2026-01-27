aws_region = "us-east-1"
project_name = "two-tier"
environment =   "prod"
cidr_block = "10.16.0.0/16"
pub-subnet-count = 2
pri-subnet-count = 2
pub-cidr-block = ["10.16.0.0/20", "10.16.16.0/20"]
pri-cidr-block = ["10.16.128.0/20", "10.16.144.0/20"]
pub-availability-zone = ["us-east-1a", "us-east-1b"]
pri-availability-zone = ["us-east-1a", "us-east-1b"]
db_name = "school"
db_user = "admin"
ec2_instance_type = "t3.micro"
db_instance_class    = "db.t3.micro"
db_allocated_storage = 10
db_engine_version    = "8.0.43"


# Comment below values if we use custom AMI Image of Two-Tier Application
asg_image_id = "ami-0a7b04c745ebb3503"
asg_instance_type = "t3.micro"
min_size = 1
max_size = 4
desired_capacity = 1