variable "aws_region" {
  description = "The AWS region to deploy resources into"
  type        = string
  default     = "ap-south-1"  
}
variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"  
}

variable "public_subnet_cidr_blocks" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)

}

variable "private_subnet_cidr_blocks" {
  description = "CIDR blocks for the private subnets"
  type        = list(string)
 
}

variable "availability_zones" {
  description = "Availability zones for the subnets"
  type        = list(string)
 
}
variable "iam_policy_name" {
  type    = string
  default = "EC2-SSH1-policy"
}

variable "role_name" {
  type    = string
  default = "EC2-SSH1-role"
}
variable "instance_profile_name" {
  description = "Instance profile name for Auto scaling Group"

}
variable "ami_id" {
  description = "The ID of the AMI to use for the instances"
  type        = string
}

variable "instance_type_jenkins" {
  description = "The instance type for the Jenkins instance"
  type        = string
}

variable "instance_type_nexus" {
  description = "The instance type for the Nexus instance"
  type        = string
}

variable "instance_type_sonarqube" {
  description = "The instance type for the SonarQube instance"
  type        = string
}
