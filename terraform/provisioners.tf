resource "null_resource" "update_kubeconfig" {

  depends_on = [
    aws_eks_cluster.wanderlust-cluster,
    aws_eks_node_group.wanderlust-eks-node
  ]

  provisioner "file" {
    source      = "../ansible/update-kubeconfig.yaml"
    destination = "/tmp/update-kubeconfig.yaml"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("wanderlust-key")
    host        = aws_instance.master.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo ansible-playbook /tmp/update-kubeconfig.yaml"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("wanderlust-key")
      host        = aws_instance.master.public_ip
    }
  }
}


resource "null_resource" "install_argocd" {

  depends_on = [
    aws_eks_cluster.wanderlust-cluster,
    aws_eks_node_group.wanderlust-eks-node,
    null_resource.update_kubeconfig,
    aws_eks_access_entry.master,
    aws_eks_access_policy_association.master_admin

  ]

  provisioner "file" {
    source      = "../ansible/argocd_setup.yaml"
    destination = "/tmp/argocd_setup.yaml"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("wanderlust-key")
    host        = aws_instance.master.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo ansible-playbook /tmp/argocd_setup.yaml"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("wanderlust-key")
      host        = aws_instance.master.public_ip
    }
  }
}
