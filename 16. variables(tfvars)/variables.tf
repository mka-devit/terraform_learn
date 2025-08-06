variable "region" {
  description   = "AWS Region to deploy resources"
  type          = string
  default       = "eu-north-1"
}
variable "instance_type" {
    description = "Type of EC2 instance"
    type        = string
    default     = "t3.micro"
}
variable "allow_ports" {
    description = "List of ports to allow in the security group"
    type        = list
    default     = ["80", "443", "22", "8080"]
}
variable "detailed_monitoring" {
    description = "Enable detailed monitoring for the EC2 instance"
    type        = bool
    default     = "true"
}
variable "common-tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {
    Owner   = "Maksim.K"
    Project = "variable-example"
  }
}
