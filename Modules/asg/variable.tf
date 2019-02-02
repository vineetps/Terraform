variable "aws_access_key" {
	description = "Access Key"
}

variable "aws_secret_key" {
	description = "Secret Key"
}
variable "vpcId" {
    description = "VPCID"
}
variable "KeyPairName" {
	description = "Key Pair Name"
}
variable "min_size" {
    description = "Min size for ASG"
    default = "1"
}
variable "max_size" {
    description = "Max size for ASG"
    default = "2"
}
variable "subnet_ids" {
    description = "List of Subnets for ASG"
}

variable "region" {
	default = "us-west-2"
	description = "Region"
}
variable "key" {
  description = "autoscaling group key name"
  type        = "string"
  default = "Name"
}  

variable "value" {
  description = "AutoScaling group value"
  type        = "string"
  default = "Name"
}
variable "ami_id" {
    description = "AMI Id"
}
variable "instance_type" {
    description = "Instance Type"
    default = "t2.micro"
}
