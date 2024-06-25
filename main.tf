terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.54"
    }
  }
}
provider "aws" {
  region = var.region
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "external" "get-public-ip" {
  program = ["curl", "http://api.ipify.org?format=json"]
}

resource "aws_security_group" "my-handicapped-security-group" {
  name        = "my-handicapped-security-group"
  description = "Allow all HTTP/HTTPS traffic"
  vpc_id      = "${data.aws_vpc.default.id}"

  ingress {
    protocol         = "tcp"
    from_port        = 80
    to_port          = 80
    self             = false
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    protocol         = "tcp"
    from_port        = 443
    to_port          = 443
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  # Staging
  ingress {
    protocol         = "tcp"
    from_port        = 8080
    to_port          = 8080
    self             = false
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    protocol         = "tcp"
    from_port        = 8043
    to_port          = 8043
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    protocol         = "icmp"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  # Current IP for executing SSH command via CI/CD
  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["${data.external.get-public-ip.result.ip}/32"]
  }

  # Similar blocks should be created for all developer machines
  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["186.4.53.135/32"]
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

module "aws-iam-role-for-ecr" {
  source      = "./modules/aws-iam-role"
  action_list = ["ecr:GetAuthorizationToken", "ecr:BatchGetImage", "ecr:GetDownloadUrlForLayer"]
  name        = "ec2-role-my-handicapped-pet"
}

resource "aws_iam_instance_profile" "my-handicapped-instance-profile" {
  name = "my-handicapped-instance-profile"
  role = module.aws-iam-role-for-ecr.name
}

resource "aws_key_pair" "instance-auth" {
  key_name   = "aws_my_handicapped_pet"
  public_key = file("${var.cert_path}/aws_my_handicapped_pet.pub")
}

resource "aws_instance" "my-handicapped-instance" {
  ami           = "ami-0b20a6f09484773af"
  instance_type = "t3.small"
  key_name      = aws_key_pair.instance-auth.key_name

  root_block_device {
    volume_size = 64
  }

  user_data = <<-EOF
#!/bin/bash
set -ex
sudo yum update -y
sudo yum install -y docker
sudo service docker start
sudo usermod -a -G docker ec2-user
  EOF

  vpc_security_group_ids = [aws_security_group.my-handicapped-security-group.id]

  iam_instance_profile = aws_iam_instance_profile.my-handicapped-instance-profile.name

  monitoring              = true
  disable_api_termination = false
  ebs_optimized           = true

  tags = {
    Name = "my-handicapped-instance"
  }
}

# TODO: add a common configuration service and connect it to the Secrets Manager.
# (currently everything is in GitHub secrets > ENV variables)
#data "aws_secretsmanager_secret" "my-handicapped-pet" {
#  name = "my-handicapped-pet/${var.env}"
#}

# build dokcer images
# for all the requested services
module "docker-image" {
  for_each = toset(var.image_list)
  source   = "./modules/docker-image"
  name     = each.value
}

# execute remotely docker-compose to bring all services up
resource "null_resource" "docker-compose-up" {
  depends_on = [module.docker-image]
  triggers   = {
    always = "${timestamp()}"
  }
  provisioner "remote-exec" {
    connection {
      host        = aws_instance.my-handicapped-instance.public_dns
      user        = "ec2-user"
      private_key = file("${var.cert_path}/aws_my_handicapped_pet")
    }

    script = "./bin/wait-instance.sh"
  }

  provisioner "local-exec" {
    command = "cp ${var.cert_path}/aws_my_handicapped_pet* ~/.ssh/"
  }

  provisioner "local-exec" {
    command = "./bin/deploy.sh"

    environment = {
      ENV         = var.env
      DOCKER_HOST = "ssh://ec2-user@${aws_instance.my-handicapped-instance.public_dns}"
    }
  }
}