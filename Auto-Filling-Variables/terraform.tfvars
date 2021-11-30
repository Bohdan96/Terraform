region                     = "eu-west-2"
instance_type              = "t4g.micro"
enable_detailed_monitoring = false

allow_ports = ["80", "443", "8080", "22"]

common_tags = {
  Owner       = "Admin"
  Project     = "Test"
  Environment = "dev"
}
