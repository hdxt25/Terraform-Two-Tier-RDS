

# VPC Module
module "vpc" {
  source = "./modules/vpc"

  project_name          = var.project_name
  environment           = var.environment
  pri-availability-zone = var.pri-availability-zone
  pri-cidr-block        = var.pri-cidr-block
  pub-subnet-count      = var.pub-subnet-count
  pri-subnet-count      = var.pri-subnet-count
  pub-cidr-block        = var.pub-cidr-block
  pub-availability-zone = var.pub-availability-zone
  cidr_block            = var.cidr_block
}

# RDS Module
module "rds" {
  source = "./modules/rds"

  project_name         = var.project_name
  environment          = var.environment
  private_subnet_ids   = module.vpc.private_subnet_ids
  db_security_group_id = module.vpc.db_sg_id
  db_name              = var.db_name
  db_user              = var.db_user
  db_password          = module.secrets.db_password
  db_instance_class    = var.db_instance_class
  db_allocated_storage = var.db_allocated_storage
  db_engine_version    = var.db_engine_version
}

# Secrets Module
module "secrets" {
  source = "./modules/secrets"

  db_name = var.db_name
  db_user = var.db_user
  db_host = module.rds.db_endpoint
}

resource "aws_iam_role" "ec2_role" {
  name = "asg-ec2-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_full_access" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}

resource "aws_iam_role_policy_attachment" "ssm_managed_instance" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "asg-ec2-ssm-profile"
  role = aws_iam_role.ec2_role.name
}

# Get latest Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.ec2_instance_type
  subnet_id                   = module.vpc.public_subnet_ids[0]
  vpc_security_group_ids      = [module.vpc.ec2_sg_id]
  associate_public_ip_address = true

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name        = "${var.project_name}-web-server"
    Environment = var.environment
  }
}

# Comment alb, asg modules before creating custom AMI Image.
module "alb" {
  source = "./modules/alb"

  project_name    = var.project_name
  environment     = var.environment
  vpc_id          = module.vpc.vpc_id
  security_groups = [module.vpc.alb_sg_id]
  subnets         = module.vpc.public_subnet_ids
}

module "asg" {
  source = "./modules/asg"

  asg_image_id              = var.asg_image_id
  asg_instance_type         = var.asg_instance_type
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  project_name              = var.project_name
  environment               = var.environment
  iam_instance_profile_name = aws_iam_instance_profile.ec2_profile.name
  asg_security_groups       = [module.vpc.ec2_sg_id]
  vpc_zone_identifier       = module.vpc.private_subnet_ids
  target_group_arns         = [module.alb.alb_target_group_arn]
}
