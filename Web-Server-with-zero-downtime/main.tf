provider "aws" {
  region = "eu-west-2"
}

data "aws_availability_zones" "available" {}
data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_security_group" "web" {
  name        = "open all ports"
  description = "Open all ports for all ip"

  dynamic "ingress" {
    for_each = ["80", "443"]
    content {
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Dynamic Security group for web"
  }
}

resource "aws_launch_configuration" "web" {
    name_prefix      = "Web-Server-Highly-Available-LC-"
    image_id         = data.aws_ami.latest_amazon_linux.id
    instance_type    = "t4g.micro"
    security_groups  = [aws_security_group.web.id]
    user_data        = file("user_data.sh")

    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "web" {
    name                 = "ASG-$(aws_launch_configuration.web.name)"
    launch_configuration = aws_launch_configuration.web.name
    min_size             = 2
    max_size             = 2
    min_elb_capacity     = 2
    vpc_zone_identifier  = [aws_default_subnet.default_subnet1.id, aws_default_subnet.default_subnet2.id]
    health_check_type    = "ELB"
    load_balancers       = [aws_elb.web.name]

    dynamic "tag" {
      for_each = {
        Name   = "Web Server via Autoscaling Groups(ASG)"
        TAGKEY = "TAGVALUE"
      }
      content{
        key                 = tag.key
        value               = tag.value
        propagate_at_launch = true
      }
    }

    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_elb" "web" {
    name               = "WebServer-HA-ELB"
    availability_zones = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
    security_groups    = [aws_security_group.web.id]
    listener {
      lb_port           = 80
      lb_protocol       = "http"
      instance_port     = 80
      instance_protocol = "http"
    }
    health_check {
      healthy_threshold   = 2
      unhealthy_threshold = 2
      timeout             = 3
      target              = "HTTP:80/"
      interval            = 10
    }

    tags = {
      Name = "WebServer-Highly-Available-ELB"
    }
}

resource "aws_default_subnet" "default_subnet1" {
      availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_default_subnet" "default_subnet2" {
      availability_zone = data.aws_availability_zones.available.names[1]
}

output "web_load_balancer_url" {
  value = "aws_elb.web.dns_name"
}
