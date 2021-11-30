provider "aws" {
  region = var.region
}

data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_eip" "statistic_ip" {
  instance = aws_instance.amazon_server.id
  tags     = merge(var.common_tags, { Name = "${var.common_tags["Environment"]} Server IP"})
}

resource "aws_instance" "amazon_server" {
  ami                    = data.aws_ami.latest_amazon_linux.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.open-all.id]
  monitoring             = var.enable_detailed_monitoring //default monitoring dont enable

  tags = var.common_tags
}

resource "aws_security_group" "open-all" {
  name = "open all ports"

  dynamic "ingress" {
    for_each = var.allow_ports
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

  tags     = merge(var.common_tags, { Name = "${var.common_tags["Environment"]} Security group"})
}
