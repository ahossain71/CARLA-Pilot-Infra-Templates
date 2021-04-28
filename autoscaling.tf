
resource "aws_launch_configuration" "carla-pilot-lnchcfg" {
    name_prefix = "carla-pilot-"
    #image_id             = "ami-094d4d00fd7462815"
    image_id              = "ami-0742b4e673072066f"
    iam_instance_profile = aws_iam_instance_profile.carla-s3-full.name
    security_groups       = [aws_security_group.carla-pilot-lnchcfg-sg.id]
    key_name = "myTestKeyPair02"
    associate_public_ip_address = true
    instance_type         = "t2.micro"
    user_data             = <<-EOF
                            #! /bin/sh
                            yum update -y
                            amazon-linux-extras install docker
                            service docker start
                            usermod -a -G docker ec2-user
                            chkconfig docker on
                            sudo mkdir -p /usr/share/dockerimages
                            cd /usr/share/dockerimages
                            aws s3 cp s3://carla-pilot/carla-pilot-images/CARLA-Pilot-Proto01.tar ./CARLA-Pilot-Proto01.tar 
                            cd ~/
                            sudo mkdir -p /opt/carla-components/CARLA-Pilot /opt/carla-components/CARLA-Studio /opt/carla-components/CARLA-Cognisearch
                            cp /usr/share/dockerimages/CARLA-Pilot-Proto01.tar /opt/carla-components/CARLA-Pilot/
                            cd /opt/carla-components/CARLA-Pilot/
                            docker load -i CARLA-Pilot-Proto01.tar
                            docker run 3000:3000 CARLA-Pilot-Proto01
                            EOF
}

resource "aws_autoscaling_group" "carla-pilot-asg" {
    name                      = "carla-pilot-asg"
    vpc_zone_identifier       = [aws_subnet.carla-pilot-prv01-sn.id, aws_subnet.carla-pilot-prv02-sn.id]
    # We want this to explicitly depend on the launch config above
    depends_on = [aws_launch_configuration.carla-pilot-lnchcfg]
    launch_configuration      = aws_launch_configuration.carla-pilot-lnchcfg.id
    target_group_arns = [aws_lb_target_group.carla-pilot-trgrp.arn] #  A list of aws_alb_target_group ARNs, for use with Application or Network Load Balancing.
    desired_capacity          = 1
    min_size                  = 1
    max_size                  = 2
    health_check_grace_period = 300
    force_delete              = true
    health_check_type         = "ELB"
    tag {
      key                 = "Name"
      value               = "carla-pilot-ec2"
      propagate_at_launch = true
  }
}

# Create a load balancer for ec2 instances, each of which would host all three system components
resource "aws_lb" "carla-pilot-lb" {
  name            = "carla-pilot-lb"
  internal        = false
  idle_timeout    = "300"
  security_groups = [aws_security_group.carla-pilot-lb-sg.id]
  subnets = [aws_subnet.carla-pilot-prv01-sn.id, aws_subnet.carla-pilot-prv02-sn.id]
 }

# Define a listener
resource "aws_lb_listener" "carla-pilot-lb-listener" {
  load_balancer_arn = aws_lb.carla-pilot-lb.arn
  port              = "3000"
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.carla-pilot-trgrp.arn
    type             = "forward"
  }
}

# Define a listener rule
#resource "aws_alb_listener_rule" "carla-pilot-lsrl" {
#  listener_arn = aws_lb_listener.carla-pilot-alb-listener.arn
#  priority     = 99
#
#  action {
#    type = "forward"
#    target_group_arn = aws_lb_target_group.carla-pilot-trgrp.arn
#  }
#  condition {
#    path_pattern {
#      values = ["/forward_to/*"]
#    }
#  }
#
#}

#Define carla-pilot target group
resource "aws_lb_target_group" "carla-pilot-trgrp" {
  name     = "carla-pilot-trgrp"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = aws_vpc.carla-pilot-vpc.id
}

#resource "aws_autoscaling_attachment" "carla-pilot-asg-attacmnt" {
#  autoscaling_group_name = aws_autoscaling_group.carla-pilot-asg.name
#  alb_target_group_arn   = aws_lb_target_group.carla-pilot-trgrp.arn
#}