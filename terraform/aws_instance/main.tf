provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file(var.public_key_path)
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_instance" "docker" {
  ami                    = var.ami_id
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "DockerInstance"
  }

  provisioner "local-exec" {
    command = "until ssh -o StrictHostKeyChecking=no -i /var/lib/jenkins/.ssh/id_ed25519 ec2-user@${self.public_ip} 'echo connected'; do echo 'Waiting for SSH...'; sleep 10; done"
    }

  provisioner "local-exec" {
    command = "ansible-playbook -i '${self.public_ip},' ansible/setup_user.yml -e ssh_key='$(cat /var/lib/jenkins/.ssh/id_ed25519.pub)' -u ec2-user --private-key=/var/lib/jenkins/.ssh/id_ed25519 --ssh-extra-args='-o StrictHostKeyChecking=no'"
    }



}
