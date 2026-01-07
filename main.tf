# Security Group
resource "aws_security_group" "nginx_sg" {
  name        = "nginx-sg-terraform-final"
  description = "Allow SSH and HTTP"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "nginx_ec2" {
  ami                         = "ami-0f5ee92e2d63afc18" # Ubuntu 22.04 Mumbai
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.nginx_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    exec > /var/log/user-data.log 2>&1
    set -xe

    sleep 30

    apt-get update -y
    apt-get install -y nginx

    systemctl enable nginx
    systemctl restart nginx
  EOF

  tags = {
    Name = "Terraform-Nginx-EC2"
  }
}
