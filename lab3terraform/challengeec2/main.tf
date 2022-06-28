data "aws_ami" "amazon2" {
  owners      = ["amazon"]
  most_recent = true
  
  filter {
    name   = "name"
    values = ["amzn2-ami*-hvm-*-x86_64-*"]
  }
  
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}


resource "aws_s3_bucket" "bucket" {
  #bucket = "bucket"

  tags = {
    Name        = "Bucket"
    Project_Name  = var.project_name
    Creator       = var.creator
    ProvisionTool = var.provisiontool
  }
  
}
resource "aws_iam_policy" "backend_policy" {
  name        = "backend_s3_policy"
  path        = "/app/"
  description = "Backend S3 IAM Policy"
  tags = {
    Project_Name  = var.project_name
    Creator       = var.creator
    ProvisionTool = var.provisiontool
  }

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject",
        ]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.bucket.arn}/*"
      },
      {
        Action = [
          "s3:ListBucket"
        ]
        Effect   = "Allow"
        Resource = aws_s3_bucket.bucket.arn
      },
    ]
  })
}

resource "aws_iam_role" "backend_role" {
  path                = "/app/"
  name                = "backend_role"
  managed_policy_arns = [aws_iam_policy.backend_policy.arn]
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Description = "IAM Role for backend instance"
    Project_Name  = var.project_name
    Creator       = var.creator
    ProvisionTool = var.provisiontool
  }
}

resource "aws_iam_instance_profile" "backend_profile" {
  name = "backend_profile"
  role = aws_iam_role.backend_role.name
  tags = {
    Project_Name  = var.project_name
    Creator       = var.creator
    ProvisionTool = var.provisiontool
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



