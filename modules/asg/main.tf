resource "aws_launch_template" "lt" {
  name = "${var.project_name}"
  image_id = var.ami
  instance_type = var.cpu
  key_name = var.key_name
  user_data = filebase64("../modules/asg/config.sh")

  vpc_security_group_ids = [ var.client_sg_id ]

  tags = {
    Name = "${var.project_name}-tpl"
  }
}

resource "aws_autoscaling_group" "asg" {
  name = "${var.project_name}-asg"
  max_size = var.max_size
  min_size = var.min_size
  desired_capacity = var.desired_cap
  health_check_grace_period = 300
  health_check_type = var.asg_health_check_type
  vpc_zone_identifier = [ var.pri_sub_3a_id, var.pri_sub_4b_id ]
  target_group_arns = [ var.tg_arn ]

  enabled_metrics = [ 
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
   ]

   metrics_granularity = "1Minute"

   launch_template {
     id = aws_launch_template.lt.id
     version = aws_launch_template.lt.latest_version
   }
}

resource "aws_autoscaling_policy" "scale_up" {
  name = "${var.project_name}-asg-scale-up}"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  adjustment_type = "ChangeInCapacity"
  scaling_adjustment = "1"
  cooldown = "300"
  policy_type = "SimpleScaling"
}

# resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
  
# }