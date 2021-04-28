#Security group for Ec2 instances launched using launch_configuration 
resource "aws_security_group" "carla-pilot-lnchcfg-sg" {
    vpc_id      = aws_vpc.carla-pilot-vpc.id

    ingress {
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
    }
    ingress {
        from_port       = 3000
        to_port         = 3000
        protocol        = "tcp"
        cidr_blocks     = ["10.0.0.0/24"]
    }
    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }
    tags = {
        Name = "carla-pilot-lnchcfg-sg"
    }
}

#Security Group for ALB
resource "aws_security_group" "carla-pilot-lb-sg" {
  vpc_id      = aws_vpc.carla-pilot-vpc.id
  name = "carla-pilot-lb-sg"
  ingress {
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
        Name = "carla-pilot-lb-sg"
  } 
}

#rds postgres security group, would be listening to CARLA-Studio (service) and or Cognisearch system component
resource "aws_security_group" "carla-pilot-rds-sg" {
    vpc_id      = aws_vpc.carla-pilot-vpc.id
    ingress {
        protocol        = "tcp"
        from_port       = 5432
        to_port         = 5432
        cidr_blocks     = ["10.0.1.0/24","10.0.2.0/24"]
        security_groups = [aws_security_group.carla-pilot-lnchcfg-sg.id] #THIS HAS TO BE CHANGED TO THE CARLA-Pilot sg
    }

    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }
    tags = {
        Name = "carla-pilot-rds-sg"
    }
}