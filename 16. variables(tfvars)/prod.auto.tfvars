# Auto fill parameters for Terraform variables file
region              = "eu-west-1"
instance_type       = "t3.micro"

allow_ports         = ["80", "443"]

detailed_monitoring = true
common-tags = {
  Owner = "Maksim.K"
  Project = "variable-exampleDEV"
  Environment = "Prod"
  Call = "54321"
}