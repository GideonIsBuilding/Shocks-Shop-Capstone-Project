variable "domain_name" {
  description = "This is the domain name"
  type        = string
  default     = "osikhena.com"
}

variable "FQDN" {
  description = "This is the domain name"
  type        = string
  default     = "osikhena.com."
}

variable "alt_domain_name" {
  description = "This is the alternative domain name"
  type        = string
  default     = "*.osikhena.com"
}

variable "acme_challenge_aws_access_key_id" {}
variable "acme_challenge_aws_secret_access_key" {}
variable "acme_challenge_aws_region" {}
