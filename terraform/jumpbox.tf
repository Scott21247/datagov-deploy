data "aws_ami" "jumpbox" {
  most_recent = true

  filter {
    name   = "name"
    values = ["jumpbox-ami *"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["self"]
}

resource "aws_security_group" "jumpbox" {
  name        = "${var.prefix}-jumpbox"
  description = "Allow administration from SSH"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "jumpbox" {
  ami           = "${data.aws_ami.jumpbox.id}"
  instance_type = "t2.micro"
  associate_public_ip_address = "true"
  key_name = "${aws_key_pair.admin.key_name}"
  vpc_security_group_ids = ["${aws_security_group.jumpbox.id}"]
  subnet_id = "${module.vpc.public_subnets[0]}"

  tags {
    Name = "${var.prefix}-jumpbox"
    Terraform = "true"
    Environment = "test"
    Owner = "${var.owner}"
  }
}
