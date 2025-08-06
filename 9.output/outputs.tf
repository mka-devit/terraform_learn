output "webserver_id" {
  value = aws_instance.my_web_server.id
}

output "webserver_ip" {
  value = aws_eip.mystati_ip.public_ip
}

output "webserver_sg_id" {
  value = aws_security_group.MyWebServerSG.id
}

output "webserver_sg_arn" {
  value = aws_security_group.MyWebServerSG.arn
  description = "This is Security Group ARN"
}