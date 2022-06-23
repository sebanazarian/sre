data "aws_vpc" "default" { #obtengo la vpc por default
  default = true
}

resource "aws_security_group" "sg_frontend" {
  name        = "http_http"
  description = "Allows http traffics only 80"
  vpc_id      = data.aws_vpc.default.id #data.aws_vpc.default.id
  ingress {
    description = "Permite el ingreso por el puerto 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "http from the internet"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.default.cidr_block]
  }
}

resource "aws_security_group" "sg_backend" {
  name        = "http_https"
  description = "Allows http and https traffics only 8080"
  vpc_id      = data.aws_vpc.default.id #data.aws_vpc.default.id
  ingress {
    description     = "Permite el ingreso por el puerto 8080"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.sg_frontend.id]
  }
  egress {
    description = "http from the internet"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.default.cidr_block]
  }
}


