# First AutoScaling Launch Configuration
resource "aws_launch_configuration" "levelup-launchconfig" {
  name_prefix     = "levelup-launchconfig"
  # This will the name prefix of all the instances launched by this particular launch configuration 
  image_id        = lookup(var.AMIS, var.AWS_REGION)
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.levelup_key.key_name # aws key par and the key name 
  security_groups = [aws_security_group.levelup-instance.id] # security group on instance 
  user_data       = "#!/bin/bash\napt-get update\napt-get -y install net-tools nginx\nMYIP=`ifconfig | grep -E '(inet 10)|(addr:10)' | awk '{ print $2 }' | cut -d ':' -f2`\necho 'Hello Team\nThis is my IP: '$MYIP > /var/www/html/index.html"
# this will help us to identify on which instance the traffic is forwarded 
  lifecycle {
    create_before_destroy = true # it will first destroy the instance if its already present 
  }
}

#Generate Key because we have removed the createinstacne file 
resource "aws_key_pair" "levelup_key" {
    key_name = "levelup_key"
    public_key = file(var.PATH_TO_PUBLIC_KEY)
}

#Autoscaling Group
resource "aws_autoscaling_group" "levelup-autoscaling" {
  name                      = "levelup-autoscaling"
  vpc_zone_identifier     = [aws_subnet.levelupvpc-public-1.id, aws_subnet.levelupvpc-public-2.id] # Define the public zone of your vpc 
  launch_configuration      = aws_launch_configuration.levelup-launchconfig.name
  min_size                  = 2 # at least 2  is ec2 instance is there 
  max_size                  = 2 
  health_check_grace_period = 200 # after 200 s continuous health check failure new instance is created 
  health_check_type         = "ELB" # here the health check is done by ELB not EC2 instance 
  load_balancers            = [aws_elb.levelup-elb.name]
  force_delete              = true

  tag {
    key                 = "Name"
    value               = "LevelUp Custom EC2 instance via LB"
    propagate_at_launch = true
  }
}

output "ELB" {
  value = aws_elb.levelup-elb.dns_name
}
## We have remove the policy and the alarms becaue now traffic will be LB not the cloud watch 