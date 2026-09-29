resource "aws_key_pair" "wanderlust-key" {
  key_name   = "wanderlust-key"
  public_key = file("./wanderlust-key.pub")
}

resource "aws_security_group" "wanderlust-sg" {
  name        = "wanderlust-sg"
  description = "WANDERLUST_EC2_SG"
  vpc_id      = module.vpc.vpc_id
  tags = {
    Name = "wanderlust-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "HTTP" {
  security_group_id = aws_security_group.wanderlust-sg.id
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "HTTPS" {
  security_group_id = aws_security_group.wanderlust-sg.id
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "SSH" {
  security_group_id = aws_security_group.wanderlust-sg.id
  from_port         = 22
  to_port           = 22
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "SMTPS" {
  security_group_id = aws_security_group.wanderlust-sg.id
  from_port         = 465
  to_port           = 465
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "SMTP" {
  security_group_id = aws_security_group.wanderlust-sg.id
  from_port         = 25
  to_port           = 25
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "Jenkins" {
  security_group_id = aws_security_group.wanderlust-sg.id
  from_port         = 8080
  to_port           = 8080
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "SonarQube" {
  security_group_id = aws_security_group.wanderlust-sg.id
  from_port         = 9000
  to_port           = 9000
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
}
resource "aws_vpc_security_group_ingress_rule" "rule_6443" {
  security_group_id = aws_security_group.wanderlust-sg.id
  from_port         = 6443
  to_port           = 6443
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "rule_6379" {
  security_group_id = aws_security_group.wanderlust-sg.id
  from_port         = 6379
  to_port           = 6379
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "rule_3000-10000" {
  security_group_id = aws_security_group.wanderlust-sg.id
  from_port         = 3000
  to_port           = 10000
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "rule_30000-32767" {
  security_group_id = aws_security_group.wanderlust-sg.id
  from_port         = 30000
  to_port           = 32767
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "Allow_all_traffic" {
  security_group_id = aws_security_group.wanderlust-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_instance" "master" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  iam_instance_profile   = aws_iam_instance_profile.master_profile.name
  region                 = local.region
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.wanderlust-sg.id]
  key_name               = aws_key_pair.wanderlust-key.key_name

  associate_public_ip_address = true
  root_block_device {
    volume_type           = "gp3"
    volume_size           = 25
    delete_on_termination = true
  }
  tags = {
    Name        = "master"
    Environment = "development"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("./wanderlust-key")
    host        = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for cloud-init...'",
      "cloud-init status --wait",
      "sudo apt-get update -y",
      "sudo apt-get install -y ansible"
    ]
  }

  provisioner "file" {
    source      = "../ansible/master_setup.yaml"
    destination = "/tmp/master_setup.yaml"
  }

  provisioner "remote-exec" {
    inline = [
      " sudo ansible-playbook /tmp/master_setup.yaml"
    ]
  }
}
