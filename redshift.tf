resource "aws_redshift_subnet_group" "redshift" {
  name = "demo-redshift-subnet-group"

  subnet_ids = [
    aws_subnet.public_subnet_1a.id
  ]
}

resource "aws_redshift_parameter_group" "redshift" {
  name   = "demo-redshift-parameter-group"
  family = "redshift-1.0"
}

resource "aws_redshift_cluster" "redshift" {
  allow_version_upgrade               = false
  automated_snapshot_retention_period = 7
  availability_zone                   = "ap-northeast-1a"

  cluster_identifier           = var.redshift_cluster_identifier
  cluster_subnet_group_name    = aws_redshift_subnet_group.redshift.name
  cluster_parameter_group_name = aws_redshift_parameter_group.redshift.name
  cluster_type                 = "single-node"
  cluster_version              = "1.0"

  database_name        = var.redshift_database_name
  encrypted            = false
  enhanced_vpc_routing = true
  iam_roles = [
    aws_iam_role.redshift.arn
  ]

  master_username              = var.redshift_master_username
  master_password              = var.redshift_master_password
  node_type                    = "dc2.large"
  number_of_nodes              = 1
  port                         = 5439
  preferred_maintenance_window = "sun:00:00-sun:00:30"
  publicly_accessible          = true
  skip_final_snapshot          = true

  vpc_security_group_ids = [
    aws_security_group.redshift_sg.id
  ]

  logging {
    enable = false
  }
}