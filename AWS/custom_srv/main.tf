data "aws_ami" "ubuntu_ami" {
  most_recent = true
  owners = ["${var.owner["${lookup(var.server_specs[0], "os_name")}"]}"]

  filter {
    name   = "name"
    values = ["${var.ami_name["${lookup(var.server_specs[0], "os_name")}"]}"]
 }
}

data "aws_ami" "centos_ami" {
  most_recent = true
  owners = ["${var.owner["${lookup(var.server_specs[1], "os_name")}"]}"]

  filter {
    name   = "name"
    values = ["${var.ami_name["${lookup(var.server_specs[1], "os_name")}"]}"]
 }
}

data "aws_ami" "windows_ami" {
  most_recent = true
  owners = ["${var.owner["${lookup(var.server_specs[2], "os_name")}"]}"]

  filter {
    name   = "name"
    values = ["${var.ami_name["${lookup(var.server_specs[2], "os_name")}"]}"]
 }
}

data "aws_security_group" "org-sg" {
  id = var.security_group_id
}

resource "aws_instance" "ubuntu_server" {
  count = lookup(var.server_specs[0], "count")

  subnet_id               = element(var.subnet_ids, count.index)
  ami                     = data.aws_ami.ubuntu_ami.id
  instance_type           = lookup(var.server_specs[0], "instance_type")
  key_name                = var.key_name
  monitoring              = true

  vpc_security_group_ids  = ["${data.aws_security_group.org-sg.id}"]
  root_block_device {
  	volume_size = lookup(var.server_specs[0], "root_vol")
  }
  tags = {
    "Name" = "${lookup(var.server_specs[0], "os_name")}-${var.team}-${count.index + 1}"
  }
}

resource "aws_instance" "centos_server" {
  count = lookup(var.server_specs[1], "count")

  subnet_id               = element(var.subnet_ids, count.index)
  ami                     = data.aws_ami.centos_ami.id
  instance_type           = lookup(var.server_specs[1], "instance_type")
  key_name                = var.key_name
  monitoring              = true

  vpc_security_group_ids  = ["${data.aws_security_group.org-sg.id}"]
  root_block_device {
  	volume_size = lookup(var.server_specs[1], "root_vol")
  }
  tags = {
    "Name" = "${lookup(var.server_specs[1], "os_name")}-${var.team}-${count.index + 1}"
  }
}


resource "aws_instance" "win_server" {
  count = lookup(var.server_specs[2], "count")

  subnet_id               = element(var.subnet_ids, count.index)
  ami                     = data.aws_ami.windows_ami.id
  instance_type           = lookup(var.server_specs[2], "instance_type")
  key_name                = var.key_name
  monitoring              = true

  vpc_security_group_ids  = ["${data.aws_security_group.org-sg.id}"]
  root_block_device {
  	volume_size = lookup(var.server_specs[2], "root_vol")
  }
  tags = {
    "Name" = "${lookup(var.server_specs[2], "os_name")}-${var.team}-${count.index + 1}"
  }
}
