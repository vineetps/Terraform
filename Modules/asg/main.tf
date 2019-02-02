provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region = "${var.region}"
}

resource "aws_launch_configuration" "launch_conf" {
  name   = "LaunchConfiguration123"
  image_id      = "${var.ami_id}"
  instance_type = "${var.instance_type}"
  security_groups  = ["${aws_security_group.PubSg1.id}"]
  lifecycle {
    create_before_destroy = true
  }  
}
resource "aws_security_group" "PubSg1" {
  name        = "allow_all"
  description = "Allow all inbound traffic"
  vpc_id      = "${var.vpcId}"
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags {
    Name = "PublicSecurityGroup1"
  }
}

resource "aws_autoscaling_group" "asg" {
  name                 = "AustoScalingGroup123"
  launch_configuration = "${aws_launch_configuration.launch_conf.name}"
  min_size             = "${var.min_size}"
  max_size             = "${var.max_size}"
  vpc_zone_identifier  = ["${var.subnet_ids}"]
  tags {
    key = "${var.key}"
    value = "${var.value}"
    propagate_at_launch = true
  } 
}

