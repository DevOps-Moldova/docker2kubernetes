module "db" {
  source  = "terraform-aws-modules/rds/aws"

  identifier = "${var.cluster_name}-db"

  engine            = "mysql"
  engine_version    = "5.7.25"
  instance_class    = var.db_instance_class
  allocated_storage = 5

  db_name  = var.db_dbname
  username = var.db_username
  port     = "3306"

  iam_database_authentication_enabled = false

  vpc_security_group_ids = [
      aws_security_group.internal_traffic.id,
      module.eks.cluster_primary_security_group_id
  ]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  monitoring_interval = "30"
  monitoring_role_name = "MyRDSMonitoringRole"
  create_monitoring_role = true

  tags = local.tags

  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = module.vpc.private_subnets

  # DB parameter group
  family = "mysql5.7"

  # DB option group
  major_engine_version = "5.7"

  # Database Deletion Protection
  deletion_protection = true

  parameters = [
    {
      name = "character_set_client"
      value = "utf8mb4"
    },
    {
      name = "character_set_server"
      value = "utf8mb4"
    }
  ]

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]
}