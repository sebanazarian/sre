output "instance_public_ip" {
  value = aws_instance.backend.public_ip
}

output "ami" {
  value = data.aws_ami.amazon2.id
}
