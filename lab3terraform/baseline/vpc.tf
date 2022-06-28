resource "aws_default_vpc" "default" {}

data "aws_vpc" "default" {
  id = "vpc-0c2399242e8a27af3"
}
resource "aws_security_group" "http_https" {
  name        = "http_https"
  description = "Allows http and https traffics only"
  vpc_id      = aws_default_vpc.default.id #data.aws_vpc.default.id
  ingress {
    description = "Https from the internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_default_vpc.default.cidr_block, "0.0.0.0/0"] #[data.aws_vpc.default.cidr_block, "0.0.0.0/0"]
  }
  ingress {
    description = "http from the internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_default_vpc.default.cidr_block, "0.0.0.0/0"]
  }
}


resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id    = aws_security_group.http_https.id
  network_interface_id = aws_instance.prod.primary_network_interface_id
}

