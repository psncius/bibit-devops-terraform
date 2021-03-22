resource "aws_launch_configuration" "ec2_launch_config" {
    name_prefix = "agent-lc-"
    image_id             = "var.ami"
    security_groups      = [aws_security_group.ec2_sg.id]
    user_data            = "install.sh"
    instance_type        = "t2.medium"
}

resource "aws_autoscaling_group" "failure_analysis_ec2_asg" {
    name                      = "asg"
    vpc_zone_identifier       = [aws_subnet.pub_subnet.id]
    launch_configuration      = aws_launch_configuration.ec2_launch_config.name

    desired_capacity          = 2
    min_size                  = 2
    max_size                  = 5
    health_check_grace_period = 300
    health_check_type         = "EC2"

    tag {
        key = "Name"
        value = "Agent Instance"
        propagate_at_launch = true
    }
}

resource "aws_autoscaling_policy" "agents-scale-up" {
    name = "agents-scale-up"
    scaling_adjustment = 1
    adjustment_type = "ChangeInCapacity"
    cooldown = 300
    autoscaling_group_name = "${aws_autoscaling_group.failure_analysis_ec2_asg.name}"
}

resource "aws_autoscaling_policy" "agents-scale-down" {
    name = "agents-scale-down"
    scaling_adjustment = -1
    adjustment_type = "ChangeInCapacity"
    cooldown = 300
    autoscaling_group_name = "${aws_autoscaling_group.failure_analysis_ec2_asg.name}"
}