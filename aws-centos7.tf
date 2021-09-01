provider "aws" {
  region     = var.aws_reg
  access_key = "${var.aws_api_key}"
  secret_key = "${var.aws_secret_key}"
}

resource "aws_key_pair" "keypair1" {
  key_name   = "pubkey"
  public_key = file(var.ssh_key)
}


data "aws_ami" "centos" {
owners      = ["679593333241"]
most_recent = true

  filter {
      name   = "name"
      values = ["CentOS Linux 7 x86_64 HVM EBS *"]
  }

  filter {
      name   = "architecture"
      values = ["x86_64"]
  }

  filter {
      name   = "root-device-type"
      values = ["ebs"]
  }
}

resource "aws_instance" "ec2" {
  ami           =  data.aws_ami.centos.id
  instance_type = "t2.micro"

  depends_on = [
    aws_db_instance.mysql,
  ]

  vpc_security_group_ids      = [aws_security_group.web.id]
  subnet_id                   = aws_subnet.public1.id
  associate_public_ip_address = true

  key_name  = aws_key_pair.keypair1.key_name

  user_data = file("files/userdata.sh")

  tags = {
    Name = "EC2 Instance"
  }
 
  provisioner "file" {
    source      = "files/userdata.sh"
    destination = "/tmp/userdata.sh"

    connection {
      type        = "ssh"
      user        = "centos"
      host        = self.public_ip
      private_key = file(var.ssh_priv_key)
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/userdata.sh",
      "/tmp/userdata.sh",
    ]

    connection {
      type        = "ssh"
      user        = "centos"
      host        = self.public_ip
      private_key = file(var.ssh_priv_key)
    }
  }

  provisioner "file" {
    content     = data.template_file.phpconfig.rendered
    destination = "/tmp/wp-config.php"

    connection {
      type        = "ssh"
      user        = "centos"
      host        = self.public_ip
      private_key = file(var.ssh_priv_key)
    }
  }
  provisioner "remote-exec" {
    inline = [
      "sudo cp /tmp/wp-config.php /var/www/html/wp-config.php",
    ]

    connection {
      type        = "ssh"
      user        = "centos"
      host        = self.public_ip
      private_key = file(var.ssh_priv_key)
    }
  }

  timeouts {
    create = "20m"
  }
}
