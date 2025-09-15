cd infra

# Inicializa
terraform init

# Revisa el plan (si usas un tfvars dedicado)
terraform plan -var-file=terraform.tfvars

# Aplica
terraform apply -var-file=terraform.tfvars
