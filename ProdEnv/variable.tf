variable "aws_access_key" {
	description = "Access Key"
}

variable "aws_secret_key" {
	description = "Secret Key"
}

variable "amiId" {
	description = "AMI ID"
	default = "ami-0a5e707736615003c"
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

variable "pwd" {
	description = "RDS Password"
	default = "Passw0rd"
}

variable "bucket_logs" {
	description = "Log Bucket Name"
	default = "LogBuckkk"
}

variable "bucket_cdn" {
	description = "CloudFront Bucket Name"
	default = "FrontBuckkk"
}

variable "rdsInstanceType" {
	default = "db.r3.large"
	description = "Instance Type for RDS"
}

variable "recordName" {
	description = "Name of Record (<recordName>.<hostedzone>) example: example.sample.com"
	default = "example"
}

variable "hostedZone" {
	description = "Name of Hosted Zone"
	default = "sample.com"
}

variable "region" {
	default = "eu-west-1"
	description = "Region"
}
