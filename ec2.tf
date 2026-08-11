# SSH Key Pair

resource "aws_key_pair" "deployer" {
  key_name   = "terraform-key"
  public_key = file("/home/uttam/.ssh/id_rsa.pub")

  tags = {
    Name = "terraform-key"
  }
}


# EC2 Instance

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  subnet_id                   = module.vpc.public_subnet_id
  vpc_security_group_ids      = [aws_security_group.web.id]
  associate_public_ip_address = true

  key_name = aws_key_pair.deployer.key_name

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install nginx -y
              systemctl enable nginx
              systemctl start nginx
              EOF

  tags = {
    Name = "${var.project_name}-web-server"
  }
}


# Elastic IP

resource "aws_eip" "web" {
  domain = "vpc"

  tags = {
    Name = "${var.project_name}-web-eip"
  }
}


# Elastic IP Association

resource "aws_eip_association" "web" {
  instance_id   = aws_instance.web.id
  allocation_id = aws_eip.web.id
}