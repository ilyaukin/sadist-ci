variable "service" {
  description = "One of Amazon's three-letter service, e.g. 'ec2'"
  type        = string
  default     = "ec2"
}

variable "policy" {
  description = "One of the AWS built-in policies #see https://us-east-1.console.aws.amazon.com/iam/home?region=us-west-2#/policies"
  type        = string
  default     = null
}

variable "action_list" {
  description = "List of actions... somewhat hardcoded in Amazon... good thing is that action name (part after the semicolon) can be wildcarded"
  type        = list(string)
  default     = null
}

variable "name" {
  description = "Name of the role, normally name of the project etc."
  type        = string
}