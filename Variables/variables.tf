variable "region" {
  description = "Enter AWS region for servers"
  type        = string
  default     = "eu-west-2"
}

variable "instance_type" {
  description = "Enter Instance type"
  type        = string
  default     = "t4.micro"
}

variable "allow_ports" {
  description = "List of ports to open for server"
  type        = list //string, list, map, boolean
  default     = ["80", "443", "8080", "22"]
}

variable "enable_detailed_monitoring" {
  type    = bool
  default = "true"
}

variable "common_tags" {
  description = "Common tags for resources"
  type        = map
  default = {
    Owner   = "Admin"
    Project = "Test"
    Environment = "Development"
  }
}
