resource "aws_vpc" "vpc" {
  cidr_block       = "10.0.0.0/16"
  tags {
    Name = "VPC"
  }
}

resource "aws_subnet" "PubSub1" {
  vpc_id     = "${aws_vpc.vpc.id}"
  cidr_block = "10.0.1.0/24"
  availability_zone = "${var.region}a"
  tags {
    Name = "PubSubnet1"
  }
}

resource "aws_subnet" "PubSub2" {
  vpc_id     = "${aws_vpc.vpc.id}"
  cidr_block = "10.0.2.0/24"
  availability_zone = "${var.region}b"
  tags {
    Name = "PubSubnet2"
  }
}

resource "aws_subnet" "PriSub1" {
  vpc_id     = "${aws_vpc.vpc.id}"
  cidr_block = "10.0.3.0/24"
  availability_zone = "${var.region}a"
  tags {
    Name = "PriSubnet1"
  }
}

resource "aws_subnet" "PriSub2" {
  vpc_id     = "${aws_vpc.vpc.id}"
  cidr_block = "10.0.4.0/24"
  availability_zone = "${var.region}b"
  tags {
    Name = "PriSubnet2"
  }
}

resource "aws_ebs_volume" "WebVol1" {
    availability_zone = "${aws_subnet.PubSub1.availability_zone}"
    size = "${var.EbsVolume}"
    tags {
        Name = "EbsVolume"
    }
}

resource "aws_security_group" "PubSg1" {
  name        = "allow_all"
  description = "Allow all inbound traffic"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  tags {
    Name = "PublicSecurityGroup1"
  }
}

resource "aws_instance" "Webinstance1" {
  ami           = "${var.amiId}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.PriSub1.id}"
  key_name = "${var.KeyPairName}"
  security_groups = ["${aws_security_group.PubSg1.id}"]
  root_block_device {
    volume_size = "${var.RootVolume}"
  }
  ebs_block_device {
    volume_size = "${aws_ebs_volume.WebVol1.id}"
    device_name = "/dev/xvda"
  } 
  tags {
    Name = "WebServer1"
  }
}

resource "aws_ebs_volume" "WebVol2" {
    availability_zone = "${aws_subnet.PubSub2.availability_zone}"
    size = "${var.EbsVolume}"
    tags {
        Name = "EbsVolume"
    }
}

resource "aws_security_group" "PubSg2" {
  name        = "allow_all"
  description = "Allow all inbound traffic"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  tags {
    Name = "PublicSecurityGroup2"
  }
}

resource "aws_instance" "Webinstance2" {
  ami           = "${var.amiId}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.PriSub1.id}"
  key_name = "${var.KeyPairName}"
  security_groups = ["${aws_security_group.PubSg2.id}"]
  root_block_device {
    volume_size = "${var.RootVolume}"
  }
  ebs_block_device {
    volume_size = "${aws_ebs_volume.WebVol2.id}"
    device_name = "/dev/xvda"
  } 
  tags {
    Name = "WebServer2"
  }
}

resource "aws_ebs_volume" "AppVol1" {
    availability_zone = "${aws_subnet.PriSub1.availability_zone}"
    size = "${var.EbsVolume}"
    tags {
        Name = "EbsVolume"
    }
}

resource "aws_security_group" "PriSg1" {
  name        = "allow_all"
  description = "Allow all inbound traffic"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  tags {
    Name = "PrivateSecurityGroup1"
  }
}

resource "aws_instance" "Appinstance1" {
  ami           = "${var.amiId}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.PriSub1.id}"
  key_name = "${var.KeyPairName}"
  security_groups = ["${aws_security_group.PriSg1.id}"]
  root_block_device {
    volume_size = "${var.RootVolume}"
  }
  ebs_block_device {
    volume_size = "${aws_ebs_volume.AppVol1.id}"
    device_name = "/dev/xvda"
  } 
  tags {
    Name = "AppServer1"
  }
}

resource "aws_ebs_volume" "AppVol2" {
    availability_zone = "${aws_subnet.PriSub2.availability_zone}"
    size = "${var.EbsVolume}"
    tags {
        Name = "EbsVolume"
    }
}

resource "aws_security_group" "PriSg2" {
  name        = "allow_all"
  description = "Allow all inbound traffic"

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  tags {
    Name = "PriavateSecurityGroup2"
  }
}

resource "aws_instance" "Appinstance2" {
  ami           = "${var.amiId}"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.PriSub1.id}"
  key_name = "${var.KeyPairName}"
  security_groups = ["${aws_security_group.PriSg2.id}"]
  root_block_device {
    volume_size = "${var.RootVolume}"
  }
  ebs_block_device {
    volume_size = "${aws_ebs_volume.AppVol2.id}"
    device_name = "/dev/xvda"
  } 
  tags {
    Name = "server"
  }
}

resource "aws_s3_bucket" "bucket-logs" {
  bucket = "${var.bucket_logs}"
  acl    = "log-delivery-write"
}

resource "aws_elb" "PublicElb" {
  name               = "PublicElb"
  availability_zones = ["${var.region}a", "${var.region}b"]

  access_logs {
    bucket        = "${var.bucket_logs}"
    bucket_prefix = "PublicElb"
  }

  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8000/"
    interval            = 30
  }

  instances                   = ["${aws_instance.Webinstance1.id}","${aws_instance.Webinstance2.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags {
    Name = "PublicElb"
  }
}

resource "aws_route53_zone" "private" {
  name = "${var.hostedZone}"

  vpc {
    vpc_id = "${aws_vpc.vpc.id}"
  }
}

resource "aws_route53_record" "route" {
  zone_id = "${aws_route53_zone.private.zone_id}"
  name    = "${var.hostedZone}"
  type    = "A"
  alias {
    name                   = "${aws_elb.PublicElb.dns_name}"
    zone_id                = "${aws_elb.PublicElb.zone_id}"
    evaluate_target_health = true
  }
}


resource "aws_elb" "PrivateElb" {
  name               = "PrivateElb"
  availability_zones = ["${var.region}a", "${var.region}b"]

  access_logs {
    bucket        = "${var.bucket_logs}"
    bucket_prefix = "PrivateElb"
  }

  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:8000/"
    interval            = 30
  }

  instances                   = ["${aws_instance.Appinstance1.id}","${aws_instance.Appinstance2.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags {
    Name = "PrivateElb"
  }
}

resource "aws_rds_cluster" "MainRDS" {
  cluster_identifier      = "aurora-cluster"
  engine                  = "aurora-mysql"
  availability_zones      = ["${aws_subnet.PriSub1.availability_zone}", "${aws_subnet.PriSub2.availability_zone}"]
  database_name           = "MainDB"
  master_username         = "admin"
  master_password         = "${var.pwd}"
  backup_retention_period = 5
  preferred_backup_window = "03:00-05:00"
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = 2
  identifier         = "aurora-cluster-${count.index}"
  cluster_identifier = "${aws_rds_cluster.MainRDS.id}"
  instance_class     = "${var.rdsInstanceType}"
}

resource "aws_db_cluster_snapshot" "example" {
  db_cluster_identifier          = "${aws_rds_cluster.MainRDS.id}"
  db_cluster_snapshot_identifier = "aurora-cluster-snapshot"
}

resource "aws_db_security_group" "RdsSg" {
  name = "RdsSg"
  ingress {
    security_group_id = "${aws_security_group.PriSg1.id}"
  }
}
