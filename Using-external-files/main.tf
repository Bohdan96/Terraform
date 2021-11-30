provider "aws" {
  region = "eu-west-2"
}

resource "aws_instance" "web-server" {
  ami                         = "ami-0d21c64d5074a949a"
  instance_type               = "t4g.micro"
  vpc_security_group_ids      = [aws_security_group.open-all.id]
  user_data                   = file("script.sh")

  tags = {
    Name = "Nginx web server"
  }
}

resource "aws_security_group" "open-all" {
  name        = "open all ports"
  description = "Open all ports for all ip"

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "All ports"
  }
}
