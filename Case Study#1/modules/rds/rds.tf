
#Call VPC Module First to get the Subnet IDs
 module "levelup-vpc" {
     source      = "../vpc"

     ENVIRONMENT = var.ENVIRONMENT
     AWS_REGION  = var.AWS_REGION
}

#Define Subnet Group for RDS Service
resource "aws_db_subnet_group" "levelup-rds-subnet-group" {

    name          = "${var.ENVIRONMENT}-levelup-db-snet"
    description   = "Allowed subnets for DB cluster instances"
    subnet_ids    = [
      "${module.levelup-vpc.levelup_vpc_private_subnet_1.id}",    # defining both the private subnet and i am taking it with the modules
      "${module.levelup-vpc.levelup_vpc_private_subnet_2.id}",
    ]
    tags = {
        Name         = "${var.ENVIRONMENT}_levelup_db_subnet"
    }
}

#Define Security Groups for RDS Instances
resource "aws_security_group" "levelup-rds-sg" {

  name = "${var.ENVIRONMENT}-levelup-rds-sg"
  description = "Created by LevelUp"
  vpc_id      = module.levelup-vpc.my_vpc_id

  ingress {
    from_port = 3306 # will accept and forward the traffic to 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["${var.RDS_CIDR}"]

  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1" # all protocol 
    cidr_blocks = ["0.0.0.0/0"]
  }

    tags = {
    Name = "${var.ENVIRONMENT}-levelup-rds-sg"
   }
}

# Defining the db instance  now 
resource "aws_db_instance" "levelup-rds" { 
  identifier = "${var.ENVIRONMENT}-levelup-rds" # name of the db instance 
  allocated_storage = var.LEVELUP_RDS_ALLOCATED_STORAGE # size you want to define for db thatt is from variable 
  storage_type = "gp2"
  engine = var.LEVELUP_RDS_ENGINE 
  engine_version = var.LEVELUP_RDS_ENGINE_VERSION
  instance_class = var.DB_INSTANCE_CLASS
  backup_retention_period = var.BACKUP_RETENTION_PERIOD
  publicly_accessible = var.PUBLICLY_ACCESSIBLE
  username = var.LEVELUP_RDS_USERNAME
  password = var.LEVELUP_RDS_PASSWORD
  vpc_security_group_ids = [aws_security_group.levelup-rds-sg.id] # the security group which we just created 
  db_subnet_group_name = aws_db_subnet_group.levelup-rds-subnet-group.name
  multi_az = "false"
}

output "rds_prod_endpoint" {
  value = aws_db_instance.levelup-rds.endpoint
}