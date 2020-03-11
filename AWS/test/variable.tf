variable "aws_access_key" {
	description = "Access Key"
}

variable "aws_secret_key" {
	description = "Secret Key"
}

variable "amiId" {
	description = "AMI ID"
}

variable "KeyPairName" {
	description = "Key Pair Name"
}


variable "RootVolume" {
	description = "Root Volume"
	default = "10"
}

variable "EbsVolume" {
	description = "EBS Volume"
	default = "10"
}
