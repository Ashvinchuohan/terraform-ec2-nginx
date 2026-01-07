output "public_ip" {
  value = aws_instance.nginx_ec2.public_ip
}
