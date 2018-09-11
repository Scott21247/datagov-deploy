data "aws_ami" "ubuntu_trusty" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_security_group" "ckan" {
  name        = "${var.prefix}-ckan"
  description = "Allow web traffic"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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

resource "aws_instance" "ckan" {
  count         = "${var.count_instances}"
  ami           = "${data.aws_ami.ubuntu_trusty.id}"
  instance_type = "t2.micro"
  key_name = "${var.admin_key_name}"
  vpc_security_group_ids = ["${aws_security_group.ckan.id}", "${var.security_groups}"]
  subnet_id = "${var.subnet_id}"

  tags {
    Name = "${var.prefix}-${count.index}"
    Terraform = "true"
    Environment = "test"
    Owner = "${var.owner}"
  }
}

module "ckan_lb" {
  source = "terraform-aws-modules/elb/aws"
  name               = "${var.prefix}-inventory-lb"
  internal           = false
  security_groups    = ["${aws_security_group.ckan.id}"]
  subnets            = ["${var.public_subnets}"]

  // ELB attachments
  number_of_instances = "${var.count_instances}"
  instances           = ["${aws_instance.ckan.*.id}"]

  listener = [
    {
      instance_port     = "80"
      instance_protocol = "HTTP"
      lb_port           = "80"
      lb_protocol       = "HTTP"
    },
  ]

  health_check = [
    {
      target              = "HTTP:80/"
      interval            = 30
      healthy_threshold   = 2
      unhealthy_threshold = 2
      timeout             = 5
    },
  ]

  tags = {
    Name        = "${var.prefix}-lb"
    Terraform   = "true"
    Owner       = "${var.owner}"
    Environment = "test"
  }
}
