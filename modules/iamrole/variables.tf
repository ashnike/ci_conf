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
  default = "EC2SSHprofile"
}