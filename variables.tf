variable "region" {
  type        = string
  description = "The region which to create resources in"
  default     = "us-west-2"
}

variable "cert_path" {
  type        = string
  description = <<-EOF
Path to the SSH certificates for the machine provisioning.
This path must contain `ssh-keygen`-generated key pair:
  aws_my_handicapped_pet
  aws_my_handicapped_pet.pub
EOF
  default     = "."
}

variable "env" {
  type        = string
  description = "Environment to provision: prod|staging"
  default     = "prod"
}

variable "image_list" {
  type        = list(string)
  description = "List of images that have to be rebuilt"
  default     = []
}
