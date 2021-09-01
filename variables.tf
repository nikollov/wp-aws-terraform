variable aws_reg {
  type        = string
  description = "Choose AWS region"
  default     = "eu-west-1"
}

variable "aws_api_key" {
  type        = string
  description = "Give user key for AWS"
}

variable "aws_secret_key" {
  type        = string
  description = "Give Secret Key for AWS"
}

variable ssh_key {
  description = "Default pub key"
  default     = "~/.ssh/id_rsa.pub"
}

variable ssh_priv_key {
  description = "Default private key"
  default     = "~/.ssh/id_rsa"
}

variable db_user {
  type        = string
  description = "Give DB username"
  default     = "admin"
}

variable db_pass {
  type        = string
  description = "Give DB password"
}

variable db_name {
  type        = string
  description = "Give worldpressDB name"
  default     = "wpdata"
}

variable stack {
  description = "this is name for tags"
  default     = "terraform"
}

