
data "aws_ami" "amazon2" {
  owners           = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}


resource "aws_instance" "frontend" {
  instance_type = var.instance_type
  ami           = data.aws_ami.amazon2.id
  tags = {
    Name = "frontend"
    Rol  = "Front End Server"
  }
}

resource "aws_instance" "backend" {
  instance_type = var.instance_type
  ami           = data.aws_ami.amazon2.id
  tags = {
    Name = "backend"
    Rol  = "Back End Server"
  }
}



