resource "aws_vpc" "vpc" {
  cidr_block       = "10.0.0.0/16"

  tags {
    Name = "VPC1"
  }
}

resource "aws_subnet" "PubSub1" {
  vpc_id     = "${aws_vpc.vpc.id}"
  cidr_block = "10.0.1.0/24"

  tags {
    Name = "PublicSubnet1"
  }
}

resource "aws_subnet" "PubSub2" {
  vpc_id     = "${aws_vpc.vpc.id}"
  cidr_block = "10.0.2.0/24"

  tags {
    Name = "PublicSubnet2"
  }
}

resource "aws_subnet" "PriSub1" {
  vpc_id     = "${aws_vpc.vpc.id}"
  cidr_block = "10.0.3.0/24"

  tags {
    Name = "PrivateSubnet1"
  }
}

resource "aws_subnet" "PriSub2" {
  vpc_id     = "${aws_vpc.vpc.id}"
  cidr_block = "10.0.4.0/24"

  tags {
    Name = "PrivateSubnet2"
  }
}

resource "aws_ebs_volume" "vol" {
    availability_zone = "${aws_subnet.PriSub1.availability_zone}"
    size = "${var.EbsVolume}"
    tags {
        Name = "EbsVolume"
    }
}

resource "aws_security_group" "sg" {
  name        = "allow_all"
  description = "Allow all inbound traffic"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "SecurityGroup"
  }
}

resource "aws_instance" "instance" {
  ami           = "${var.amiId}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.PriSub1.id}"
  key_name = "${var.KeyPairName}"
  security_groups = ["${aws_security_group.sg.id}"]
  root_block_device {
  	volume_size = "${var.RootVolume}"
  }
  ebs_block_device {
  	volume_size = "${aws_ebs_volume.vol.id}"
  	device_name = "/dev/xvda"
  } 
  tags {
    Name = "server"
  }
}
