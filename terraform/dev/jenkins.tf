resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "cloud_pem" {
  filename        = "${path.module}/ssh_key"
  content         = tls_private_key.ssh_key.private_key_pem
  file_permission = "0500"
}


resource "aws_key_pair" "terraform" {
  key_name   = "terraform-${var.cluster_name}"
  public_key = tls_private_key.ssh_key.public_key_openssh
}



resource "aws_instance" "jenkins" {
  availability_zone = var.availability_zones[0]
  ami               = data.aws_ami.ubuntu.id
  tags = merge({
    Name    = "demo-jenkins"
    control = "yes"
    vpn     = "yes"
    },
    local.tags
  )

  instance_type = var.jenkins_instance_size
  key_name      = aws_key_pair.terraform.key_name
  subnet_id     = element(module.vpc.public_subnets, 0)
  vpc_security_group_ids = [
    aws_security_group.allow_outgoing_traffic.id,
    aws_security_group.whitelisted_traffic.id,
    aws_security_group.internal_traffic.id,
  ]

  root_block_device {
    volume_size = 20
  }

  provisioner "file" {
    source      = "${path.module}/files/provisioner.sh"
    destination = "/tmp/provisioner.sh"
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = tls_private_key.ssh_key.private_key_pem
      host        = self.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "export SSH_USER=${var.ssh_user}",
      "export SSH_PUB_KEY='${tls_private_key.ssh_key.public_key_openssh}' ",
      "chmod +x /tmp/provisioner.sh",
      "sh /tmp/provisioner.sh",
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = tls_private_key.ssh_key.private_key_pem
      host        = self.public_ip
    }
  }
}

