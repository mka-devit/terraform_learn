provider "aws" {}

data "aws_availability_zones" "working" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_vpcs" "my_vpcs" {}
data "aws_vpc" "my_defaults" {
    tags = {
        Name = "prod"
    }
}


resource "aws_subnet" "default_subnet1" {
  vpc_id = data.aws_vpc.my_defaults.id
  availability_zone = data.aws_availability_zones.working.names[1]
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "subnet-1 in ${data.aws_availability_zones.working.names[1]}"
    Account = "subnet-1 in account ${data.aws_caller_identity.current.account_id}"
    Region = data.aws_region.current.name
  }
}
resource "aws_subnet" "default_subnet2" {
  vpc_id = data.aws_vpc.my_defaults.id
  availability_zone = data.aws_availability_zones.working.names[2]
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "subnet-2 in ${data.aws_availability_zones.working.names[2]}"
    Account = "subnet-2 in account ${data.aws_caller_identity.current.account_id}"
    Region = data.aws_region.current.name
  }
}




output "default_vpc_id" {
  value = data.aws_vpc.my_defaults.id
}
output "default_vpc_cidr_block" {
  value = data.aws_vpc.my_defaults.cidr_block
}

output "data_availability_zones" {
  value = data.aws_availability_zones.working.names
}
output "data_caller_identity" {
  value = data.aws_caller_identity.current.account_id
}
output "data_region_name" {
  value = data.aws_region.current.name
}
output "data_region_description" {
  value = data.aws_region.current.description
}
output "names_of_vpcs" {
  value = data.aws_vpcs.my_vpcs.ids
  
}