# Configure AWS Provider
provider "aws" {
  region = "us-east-1"  # Change this to your desired region
}

# Data source for Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical's AWS account ID
}

# EC2 Instance
resource "aws_instance" "ubuntu_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.large"
  key_name      = "mykey"  # Your key pair name without the .pem extension

  vpc_security_group_ids = ["sg-0fe1c471d9c194bd4"]

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
    delete_on_termination = true
  }

  tags = {
    Name = "Ubuntu-Instance"
    Environment = "Development"
    ManagedBy = "Terraform"
  }
}

# Output the instance's public IP
output "public_ip" {
  value = aws_instance.ubuntu_instance.public_ip
}

# Output the instance's private IP
output "private_ip" {
  value = aws_instance.ubuntu_instance.private_ip
}