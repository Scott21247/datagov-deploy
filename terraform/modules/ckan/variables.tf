variable "prefix" {
  description = ""
}

variable "count_instances" {
  description = "The number of ckan instances to create"
  default = 1
}

variable "count_harvester_instances" {
  description = "The number of harvester instances to create"
  default = 0
}

variable "subnet_id" {
  description = "The private subnet to attach instances to"
}

variable "public_subnets" {
  description = "The public subnets to attach the ELB to"
  type = "list"
}

variable "vpc_id" {
  description = "The virtual private cloud to use for all resources"
}

variable "security_groups" {
  type = "list"
  description = "List of security groups to apply to ckan instances"
}

variable "admin_key_name" {
  description = "Name of the SSH keypair to add to the ckan instances"
}

variable "owner" {
  description = "Your name to tag resources."
}
