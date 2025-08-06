#Local Variables
provider "aws" {
    region = var.region
}


data "aws_region" "current" {}
data "aws_availability_zones" "available" {}


locals {
  full_project_name = "${var.project_name}-${var.environment}"
  project_owner = "${var.owner} owner of ${var.project_name}"
}
locals {
  country = "eu"
  city = "Stockholm"
  az_list = join(",", data.aws_availability_zones.available.names)
  region = data.aws_region.current.description
  location = "IN ${local.region} there are AZ: ${local.az_list}"
}

resource "aws_eip" "my_static_ip" {
    tags = {
        Name = "MyStaticIP"
        Owner= var.owner
        Project = local.full_project_name
        proj_owner = local.project_owner
        city = local.city
        country = local.country
        az_local= local.az_list
        local = local.location
    }
}
