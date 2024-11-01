variable "region" {
  description = "The AWS region to create resources in"
  default     = "us-east-1" # Change this to your desired region
}

variable "ssh_key_name" {
  description = "The name of the SSH key pair to use"
  default     = "amazon" # Key name as per your instruction
}
