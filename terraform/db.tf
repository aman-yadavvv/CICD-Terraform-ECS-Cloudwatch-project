resource "aws_db_subnet_group" "strapi_db_subnet_group" {
  name        = "strapi-db-subnet-group"
  description = "Subnet group for the strapi database"
  subnet_ids  = [aws_subnet.private.id, aws_subnet.private2.id]
}

resource "aws_db_instance" "strapi_db" {
  identifier        = "strapi-db"
  allocated_storage = 20
  engine            = "postgres"
  engine_version    = "15"
  instance_class    = "db.t3.micro"

  db_name  = "strapi"
  port     = 5432
  username = "strapi"
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.strapi_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  skip_final_snapshot = true
  publicly_accessible = false
  multi_az            = false
}



