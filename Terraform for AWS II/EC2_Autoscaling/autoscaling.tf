# First AutoScaling Launch Configuration
resource "aws_launch_configuration" "levelup-launchconfig" {
  name_prefix     = "levelup-launchconfig"
  # This will the name prefix of all the instances launched by this particular launch configuration 
  image_id        = lookup(var.AMIS, var.AWS_REGION)
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.levelup_key.key_name # aws key par and the key name 
}

#Generate Key because we have removed the createinstacne file 
resource "aws_key_pair" "levelup_key" {
    key_name = "levelup_key"
    public_key = file(var.PATH_TO_PUBLIC_KEY)
}

#Autoscaling Group
resource "aws_autoscaling_group" "levelup-autoscaling" {
  name                      = "levelup-autoscaling"
  vpc_zone_identifier       = ["us-east-2b"] # in which zone the instance can be created 
  launch_configuration      = aws_launch_configuration.levelup-launchconfig.name
  min_size                  = 1 # at least one is ec2 instance is there 
  max_size                  = 2 
  health_check_grace_period = 200 # after 200 s continuous health check failure new instance is created 
  health_check_type         = "EC2"
  force_delete              = true

  tag {
    key                 = "Name"
    value               = "LevelUp Custom EC2 instance"
    propagate_at_launch = true
  }
}

#Autoscaling Configuration policy - Scaling Alarm
resource "aws_autoscaling_policy" "levelup-cpu-policy" {
  name                   = "levelup-cpu-policy"
  autoscaling_group_name = aws_autoscaling_group.levelup-autoscaling.name # on which group this policy is applied 
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1" # it means scale the node 1 by one 
  cooldown               = "200"
  policy_type            = "SimpleScaling" # scaling policy type 
}

#Auto scaling Cloud Watch Monitoring
resource "aws_cloudwatch_metric_alarm" "levelup-cpu-alarm" {
  alarm_name          = "levelup-cpu-alarm"
  alarm_description   = "Alarm once CPU Uses Increase"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"
  # means for 120 sec it will monitor the two evaluation and thresshold is 30 %  means in a period of 120s
  # it there is two evaluation where the average CPU is going above 30 %   then this alarm will be triggered 

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.levelup-autoscaling.name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.levelup-cpu-policy.arn]

# means once this alarm is triggerd what is the action this alarm will perform so here i am defining the policy name 
# means to increase the ec2 instance  
}

#Auto Descaling Policy
resource "aws_autoscaling_policy" "levelup-cpu-policy-scaledown" {
  name                   = "levelup-cpu-policy-scaledown"
  autoscaling_group_name = aws_autoscaling_group.levelup-autoscaling.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1" # this time we are decreasing the node one by one 
  cooldown               = "200"
  policy_type            = "SimpleScaling"
}

#Auto descaling cloud watch 
resource "aws_cloudwatch_metric_alarm" "levelup-cpu-alarm-scaledown" {
  alarm_name          = "levelup-cpu-alarm-scaledown"
  alarm_description   = "Alarm once CPU Uses Decrease"
  comparison_operator = "LessThanOrEqualToThreshold" # change the comprsion operator as well 
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "10"
# it will decale if the average cpu thresshold is less then 10 % 
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.levelup-autoscaling.name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.levelup-cpu-policy-scaledown.arn] # change the policy name here 
}