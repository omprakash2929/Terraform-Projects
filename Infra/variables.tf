variable "env" {
  description = "This is the environment for Infra"
  type = string
}

variable "bucket_name" {
  description = "This is the environment for Infra"
  type = string
}

variable "instance_count" {
  description = "This is Number of EC2 insatance"
  type = number
}
variable "Ec2_instance_type" {
  description = "This is EC2 insatance types for Infra"
  type = string
}

variable "Ec2_ami_id" {
  description = "This is EC2 insatance AMI ID for Infra"
  type = string
}

variable "ec2_deafult_root_storage_size" {
  default = 15
   description = "This is EC2 insatance Storage Size"
  type = number
}