terraform {
  backend "s3" {
    bucket         = "lucasrod16-tfstate"
    key            = "k3s-aws/tfstate"
    region         = "us-east-2"
    dynamodb_table = "lucasrod16-tfstate"
  }
}

provider "aws" {
  region = "us-east-2"
}

data "http" "my_ip" {
  url = "https://checkip.amazonaws.com"
}

resource "aws_security_group" "k3s_sg" {
  name        = "api_security_group"
  description = "Allow inbound HTTPS, SSH, and Kube API access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${trimspace(data.http.my_ip.response_body)}/32"]
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["${trimspace(data.http.my_ip.response_body)}/32"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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

resource "aws_key_pair" "ssh_key" {
  key_name   = "api-key-pair"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "k3s_server" {
  ami             = "ami-080cfc111ab852b01"
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.ssh_key.key_name
  security_groups = [aws_security_group.k3s_sg.name]
  user_data       = file("./user_data.sh")
}

output "instance_ip" {
  value = aws_instance.k3s_server.public_ip
}

output "instance_id" {
  value = aws_instance.k3s_server.id
}
