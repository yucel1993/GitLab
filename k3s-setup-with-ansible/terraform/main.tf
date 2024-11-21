provider "aws" {
  region = var.region
}

# Create a new SSH key pair
resource "tls_private_key" "k3s_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "k3s_key" {
  key_name   = "k3s_key"                                  # New key name to avoid conflict
  public_key = tls_private_key.k3s_key.public_key_openssh # Use the generated public key
}

resource "aws_instance" "agent" {
  ami           = "ami-0866a3c8686eaeeba"
  instance_type = "t2.medium"
  key_name      = aws_key_pair.k3s_key.key_name # Use the new key pair
  tags = {
    Name = "K3s-Agent"
  }

  security_groups = [aws_security_group.k3s_security_group.name]
}

resource "aws_instance" "master" {
  ami           = "ami-0866a3c8686eaeeba"
  instance_type = "t3.medium"
  key_name      = aws_key_pair.k3s_key.key_name # Use the new key pair
  tags = {
    Name = "K3s-Master"
  }

  # User data to install K3s
   user_data = templatefile("${path.module}/userdata.sh", {})

  security_groups = [aws_security_group.k3s_security_group.name]
}

resource "aws_security_group" "k3s_security_group" {
  name        = "k3s_security_group"
  description = "Allow necessary ports for K3s communication"


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Internal K3s networking !!!
  ingress {
    from_port   = 8472
    to_port     = 8472
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Optional ports for extended K3s functionality !!!!
  ingress {
    from_port   = 4789
    to_port     = 4789
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 10251
    to_port     = 10251
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 10252
    to_port     = 10252
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
