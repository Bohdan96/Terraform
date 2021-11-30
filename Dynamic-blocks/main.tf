provider "aws" {
  region = "eu-west-2"
}

resource "aws_security_group" "open-all" {
  name        = "open all ports"
  description = "Open all ports for all ip"

  dynamic "ingress" {
    for_each = ["80", "443", "8080", "3306"]
    content {
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  ingress {
    from_port    = "22"
    to_port      = "22"
    protocol     = "tcp"
    cidr_blocks  = ["192.168.88.0/24"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Dynamic Security group"
  }
}
