# Password aleatoria si no se provee
resource "random_password" "db" {
  length  = 16
  special = true
}

resource "aws_db_subnet_group" "db" {
  name       = "eks-db-subnet-group"
  subnet_ids = aws_subnet.public[*].id
  tags       = var.tags
}

resource "aws_security_group" "db_sg" {
  name        = "eks-db-sg"
  description = "Allow public access to RDS Postgres (⚠️ demo)"
  vpc_id      = aws_vpc.eks_vpc.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # ⚠️ abre al mundo, ajusta a tu rango
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_db_instance" "eks_postgres" {
  identifier             = var.db_identifier
  engine                 = "postgres"
  instance_class         = var.db_instance_class
  allocated_storage      = var.db_allocated_storage
  username               = var.db_username
  password               = local.db_password_effective
  db_name                = var.db_name
  db_subnet_group_name   = aws_db_subnet_group.db.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  publicly_accessible    = var.db_publicly_accessible
  skip_final_snapshot    = var.db_skip_final_snapshot

  tags = var.tags
}
