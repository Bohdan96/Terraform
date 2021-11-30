locals {
  ssh_user          = "ubuntu"
  key_name          = "devops"
  private_key_path  = "/home/user/Downloads/devops.pem"
}

provider "aws" {
  region      = "eu-west-2"
}

resource "aws_instance" "ubuntu_1" {
  ami                         = "ami-095234c46886378ab"
  subnet_id                   = "subnet-0f6fa9ce38fc59060"
  vpc_security_group_ids      = ["sg-0a8e525b2cf22a0e2"]
  instance_type               = "t4g.micro"
  associate_public_ip_address = true
  key_name                    = local.key_name

  tags = {
  Name = "First server"
}

  provisioner "remote-exec" {
    inline = ["echo 'Wait until SSH is ready'"]

    connection {
      type        = "ssh"
      user        = local.ssh_user
      private_key = file(local.private_key_path)
      host        = aws_instance.ubuntu_1.public_ip
    }
  }
  provisioner "local-exec" {
    command = "ansible-playbook  -i ${aws_instance.ubuntu_1.public_ip}, --private-key ${local.private_key_path} docker.yml"
  }
}

resource "aws_instance" "ubuntu_2" {
  ami                         = "ami-095234c46886378ab"
  subnet_id                   = "subnet-0f6fa9ce38fc59060"
  vpc_security_group_ids      = ["sg-0a8e525b2cf22a0e2"]
  instance_type               = "t4g.micro"
  associate_public_ip_address = true
  key_name                    = local.key_name

  tags = {
  Name = "Second server"
}

  provisioner "remote-exec" {
    inline = ["echo 'Wait until SSH is ready'"]

    connection {
      type        = "ssh"
      user        = local.ssh_user
      private_key = file(local.private_key_path)
      host        = aws_instance.ubuntu_2.public_ip
    }
  }
  provisioner "local-exec" {
    command = "ansible-playbook  -i ${aws_instance.ubuntu_2.public_ip}, --private-key ${local.private_key_path} docker.yml"
  }
}

output "First_server_ip" {
  value = aws_instance.ubuntu_1.public_ip
}

output "Second_server_ip" {
  value = aws_instance.ubuntu_2.public_ip
}
