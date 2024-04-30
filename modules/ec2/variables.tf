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
variable "vpc_id" {
  description = "The ID of the VPC"
}
variable "public_subnet_ids" {
  description = "A list of public subnet IDs where the EC2 instance will be launched."
  # Add any other necessary attributes
}

variable "instance_profile_name" {
  description = "The name of the IAM instance profile attached to the EC2 instance."
  # Add any other necessary attributes
}
