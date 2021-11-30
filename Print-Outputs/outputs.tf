output "webserver_instance_id" {
  value = aws_instance.web-server.id
}

output "webserver_public_ip" {
  value = aws_eip.static_ip.public_ip
}
