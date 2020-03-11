variable "server_specs" {
  type = list
  default = [
    {
      os_name = "ubuntu"
      count = 0
      instance_type = "t3.micro"
      root_vol = 8
    },
    {
      os_name = "centos"
      count = 0
      instance_type = "t3.micro"
      root_vol = 8
    },
    {
      os_name = "windows"
      count = 0
      instance_type = "t3.micro"
      root_vol = 8
    }
  ]
}

variable "ami_name" {
  type = map
  default = {
    ubuntu = "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"
    centos = "amzn2-ami-hvm-*-x86_64*"
    windows = "Windows_Server-2019-English-Full-Base-*"
  }
}

variable "owner" {
  type = map
  default = {
    ubuntu = "099720109477"
    centos = "137112412989"
    windows = "801119661308"
  }
}

variable "region" {
  type = string
  default = "us-east-1"
}

variable "key_name" {
  type = string  
  default = "key-name"
}

variable "subnet_ids" {
  type = list(string)
  default = ["subnet-1","subnet-2","subnet-3"]
}

variable "security_group_id" {
  type = string
  default = "sg-1234"
}


variable "team" {
  type = string
  default = "team-name"
}
