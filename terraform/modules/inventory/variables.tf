variable "prefix" {
  description = ""
}

variable "count_instances" {
  description = "The number of catalog instances to create"
  default = 1
}

variable "subnet_id" {
  description = "The subnet to attach instances to"
}

variable "vpc_id" {
  description = "The subnet to attach instances to"
}

variable "security_groups" {
  type = "list"
  description = "List of security groups to apply to catalog instances"
}

variable "admin_key_name" {
  description = "Name of the SSH keypair to add to the catalog instances"
}

variable "owner" {
  description = "Your name to tag resources."
}
