# Terraform-Two-Tier-RDS

terraform init

terraform validate

terraform plan -var-file=dev.tfvars

terraform apply --auto-approve -var-file=dev.tfvars

terraform destroy --auto-approve -var-file=dev.tfvars