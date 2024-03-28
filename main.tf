resource "aws_instance" "jenkins" {
  ami                         = var.image_id
  instance_type               = var.server_type
  key_name                    = aws_key_pair.jenkins_key.key_name
  vpc_security_group_ids      = [aws_security_group.jenkins_server_sg.id]
  user_data                   = <<-EOF
  #!/bin/bash
  sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo
  sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io-2023.key
  sudo yum upgrade
  sudo dnf install java-17-amazon-corretto -y
  sudo yum install jenkins -y
  sudo systemctl enable jenkins
  sudo systemctl start jenkins
  EOF
  user_data_replace_on_change = true
  tags = {
    Name = var.server_name
  }
}

resource "aws_security_group" "jenkins_server_sg" {
  name        = var.sg_name
  description = var.sg_description
}

resource "aws_vpc_security_group_ingress_rule" "ssh_ingress_rule" {
  security_group_id = aws_security_group.jenkins_server_sg.id
  cidr_ipv4         = var.ssh_ingress_cidr
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "http_ingress_rule" {
  security_group_id = aws_security_group.jenkins_server_sg.id
  cidr_ipv4         = var.http_ingress_cidr
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "jenkins_ingress_rule" {
  security_group_id = aws_security_group.jenkins_server_sg.id
  cidr_ipv4         = var.jenkins_ingress_cidr
  from_port         = 8080
  to_port           = 8080
  ip_protocol       = "tcp"
}


resource "aws_vpc_security_group_egress_rule" "allow_egress" {
  security_group_id = aws_security_group.jenkins_server_sg.id
  cidr_ipv4         = var.server_egress_cidr
  ip_protocol       = var.server_egress_protocol
}

resource "tls_private_key" "generated" {
  algorithm = var.tls_algorithm
}

resource "local_file" "jenkins_key" {
  content         = tls_private_key.generated.private_key_pem
  filename        = var.kp_filename
  file_permission = var.key_pair_file_permission
}

resource "aws_key_pair" "jenkins_key" {
  key_name   = var.public_key_name
  public_key = tls_private_key.generated.public_key_openssh

  lifecycle {
    ignore_changes = [key_name]
  }
}

resource "aws_s3_bucket" "s3_name" {
  bucket        = var.s3_name
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "Mutumbo" {
  bucket                  = var.s3_name
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

