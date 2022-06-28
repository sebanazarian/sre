provider "aws" {
  region  = "us-east-1"
  profile = "default"
}


resource "aws_instance" "prod" {
  instance_type = var.instance_type
  ami           = "ami-0915bcb5fa77e4892"
  key_name      = aws_key_pair.user_ssh.key_name
  user_data     = file("./scripts/init.sh")
  # security_groups = []
}


resource "aws_key_pair" "user_ssh" {
  key_name   = "ssh_instance_key"
  public_key = file("~/.ssh/id_rsa.pub")
}
