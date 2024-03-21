variable "vpc_name" {
  type        = string
}

variable "vpc_cidr_block" {
  type        = string
}

variable "vpc_availability_zones" {
  type        = list(string)
}

variable "vpc_public_subnets" {
  type        = list(string)
}

variable "vpc_private_subnets" {
  type        = list(string)
}

variable "vpc_database_subnets" {
  type        = list(string)
}

variable "vpc_create_database_subnet_group" {
  type        = bool
}

variable "vpc_create_database_subnet_route_table" {
  type        = bool
}

variable "vpc_enable_nat_gateway" {
  type        = bool
}

variable "vpc_single_nat_gateway" {
  type        = bool
}

variable "vpc_enable_dns_hostnames" {
  type        = bool
}

variable "vpc_enable_dns_support" {
  type        = bool
}