# Auto fill parameters for Terraform variables file
region              = "eu-west-1"
instance_type       = "t2.micro"

allow_ports         = ["80", "443", "22", "8080"]

detailed_monitoring = false
common-tags = {
  Owner = "Maksim.K"
  Project = "variable-exampleDEV"
  Environment = "Dev"
  Call = "12345"
}
