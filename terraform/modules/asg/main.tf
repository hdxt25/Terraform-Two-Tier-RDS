
resource "aws_launch_template" "app_lt" {
  name_prefix   = "myapp-lt-"
  image_id      = var.asg_image_id
  instance_type = var.asg_instance_type

  iam_instance_profile {
    name = var.iam_instance_profile_name
  }
  network_interfaces {
    associate_public_ip_address = false
    security_groups             = var.asg_security_groups
  }
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.project_name}-lt"
    }
  }
}

resource "aws_autoscaling_group" "app_asg" {
  name = "${var.project_name}-asg"

  min_size         = var.min_size
  max_size         = var.max_size
  desired_capacity = var.desired_capacity

  vpc_zone_identifier = var.vpc_zone_identifier

  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }

  target_group_arns = var.target_group_arns

  tag {
    key                 = "Name"
    value               = "${var.project_name}-asg"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }
}


