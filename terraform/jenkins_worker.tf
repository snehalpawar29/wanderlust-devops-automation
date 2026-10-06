resource "aws_instance" "jenkins-worker" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  iam_instance_profile   = aws_iam_instance_profile.jenkins_worker_profile.name
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
    Name        = "jenkins-worker"
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
    source      = "../ansible/jenkins_worker_setup.yaml"
    destination = "/tmp/jenkins_worker_setup.yaml"
  }

  provisioner "remote-exec" {
    inline = [
      " sudo ansible-playbook /tmp/jenkins_worker_setup.yaml"
    ]
  }
}
