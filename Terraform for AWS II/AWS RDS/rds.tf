#RDS Resources

# First we are defining the subnet group with name maria-subnets
resource "aws_db_subnet_group" "mariadb-subnets" {
  name        = "mariadb-subnets"
  description = "Amazon RDS subnet group"
  subnet_ids  = [aws_subnet.levelupvpc-private-1.id, aws_subnet.levelupvpc-private-2.id]
  # Here i am defining two and both the subnets are in different availabality zone check the vpc.tf file 

}

# 2nd we need to define the security group  which is defined with name allow-mariadb in secrutiy_group.tf

# 3rd RDS Parameters
resource "aws_db_parameter_group" "levelup-mariadb-parameters" {
  name        = "levelup-mariadb-parameters"
  family      = "mariadb10.4" # This is the version 
  description = "MariaDB parameter group"

  parameter {
    name  = "max_allowed_packet"
    value = "16777216"
  }
}

# 4rth RDS Instance properties
resource "aws_db_instance" "levelup-mariadb" {
  allocated_storage       = 20             # 20 GB of storage
  engine                  = "mariadb"
  engine_version          = "10.4.8"
  instance_class          = "db.t2.micro"  # use micro if you want to use the free tier
  identifier              = "mariadb"
  name                    = "mariadb"
  username                = "root"           # username
  password                = "mariadb141"     # password
  db_subnet_group_name    = aws_db_subnet_group.mariadb-subnets.name # it will take private 1 and 2 as subnet 
  parameter_group_name    = aws_db_parameter_group.levelup-mariadb-parameters.name
  multi_az                = "false"            # set to true to have high availability: 2 instances synchronized with each other in useast 1a and b 
  vpc_security_group_ids  = [aws_security_group.allow-mariadb.id]
  storage_type            = "gp2"
  backup_retention_period = 30                                          # how long you’re going to keep your backups
  availability_zone       = aws_subnet.levelupvpc-private-1.availability_zone # prefered AZ
  skip_final_snapshot     = true                                        # skip final snapshot when doing terraform destroy
  
  tags = {
    Name = "levelup-mariadb"
  }
}

output "rds" {
  value = aws_db_instance.levelup-mariadb.endpoint
}

