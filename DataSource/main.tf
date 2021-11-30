provider "aws" {}

data "aws_availability_zones" "working" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

output "data_aws_availability_zones" {
  value = data.aws_availability_zones.working.names
}

output "data_aws_availability_zones" {
  value = data.aws_availability_zones.working.names[1]
}

output "data_aws_region" {
  value = data.aws_region.current.name
}
