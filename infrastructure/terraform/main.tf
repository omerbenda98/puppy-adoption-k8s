# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Reference existing VPC
data "aws_vpc" "existing" {
  id = "vpc-00f49b464688dacfd"
}

# Security Group
resource "aws_security_group" "minikube" {
  name        = "launch-wizard-2"
  description = "launch-wizard-2 created 2024-12-03T15:45:42.709Z"
  vpc_id      = data.aws_vpc.existing.id

  # SSH access from specific IPs
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["147.235.193.243/32", "80.230.12.125/32", "79.177.133.120/32"]
  }

  # HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Jenkins port
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "jenkins port"
  }

  # Port 8090
  ingress {
    from_port   = 8090
    to_port     = 8090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Minikube API
  ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["79.177.133.120/32"]
    description = "Minikube API"
  }

  # NodePort range
  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Ingress HTTP NodePort"
  }

  # ICMP
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "launch-wizard-2"
  }
}

# EC2 Instance
resource "aws_instance" "minikube" {
  ami               = "ami-0e2c8caa4b6378d8c"
  instance_type     = "t3.large"
  availability_zone = "us-east-1f"
  key_name          = "mykey"

  vpc_security_group_ids = [aws_security_group.minikube.id]
  subnet_id              = "subnet-0ae48082e8966a63b"

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  tags = {
    Name = "minikube"
  }
}

# Existing Elastic IP
data "aws_eip" "existing" {
  id = "eipalloc-0edefba4cab82f23e"
}

# EIP Association
resource "aws_eip_association" "minikube" {
  instance_id   = aws_instance.minikube.id
  allocation_id = data.aws_eip.existing.id
}

# Outputs
output "instance_id" {
  value = aws_instance.minikube.id
}

output "elastic_ip" {
  value = data.aws_eip.existing.public_ip
}