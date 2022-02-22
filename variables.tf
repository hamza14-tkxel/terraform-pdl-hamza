variable "terraform_workspace" {
  description = "Terraform Cloud workspace"
  type = string
}

variable "account_region" {
  description = "AWS Deployment region associated with the infrastructure."
  default     = "us-east-1"
}

variable "aws_account_num" {
  description = "AWS Account Number associated."
  type        = string
}

variable "AWS_ACCESS_KEY" {
  description = "AWS Access Key associated with the role."
  type        = string
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "AWS Secret Key associated with the role."
  type        = string
}

variable "env" {
  description = "Environment name for the client. Example: dev, tst or prod."
  type        = string
}

variable "ec2_os_version" {
  description = "Ubuntu OS version for EC2"
  type        = string
}


variable "client_domain" {
  description = "Client Route53 domain"
  type        = string
}

variable "client_code" {
  description = "Unique 3 to 5 character alphanumeric string for the client."
  type        = string
}


variable "cidr_block" {
  description = "cidr_block = .."
  type        = string
}


variable "public_eip" {
  description = "If true then it will create elastic ip otherwise not"
  type        = bool
}

variable "ec2_instance_family_type" {
  description = "Can put default t2.micro"
  type        = string
}

variable "ec2_key" {
  description = "Desired name of AWS key pair"
  type        = string
}

variable "role_max_session_duration" {
  type        = string
  description = "The maximum session duration (in seconds) that you want to set for the specified role. If you do not specify a value for this setting, the default maximum of one hour is applied. This setting can have a value from 1 hour to 12 hours."
}

variable "pdl_account_num" {
  type        = string
  description = "AWS Account Number for the master account"
}
