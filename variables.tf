variable "image_id" {
  type = string
  description = "The id of the machine image (AMI) to use for the server."
  default = "ami-0440d3b780d96b29d"
}

variable "server_name" {
  type = string
  description = "The name to use for the server, in the tag selection."
  default = "jenkins_ec2"
}

variable "server_type" {
  type = string
  description = "The instance type t use fo the server"
  default = "t2.micro"
}

variable "sg_name" {
  type = string
  description = "The security group name"
  default = "jenkins_sg"
}

variable "sg_description" {
  type = string
  description = "Description for server security group"
  default = "Allows inbound ssh, web, and 8080 traffic, and all outbound traffic"
}

variable "http_ingress_cidr" {
  type = string
  default = "0.0.0.0/0"
}

variable "ssh_ingress_cidr" {
  type = string
  default = "0.0.0.0/0"
}

variable "jenkins_ingress_cidr" {
  type = string
  default = "0.0.0.0/0"
}

variable "server_egress_cidr" {
  type = string
  default = "0.0.0.0/0"
}

variable "server_egress_protocol" {
  type = string
  default = "-1"
}

variable "public_key_name" {
  type = string
  default = "jenkins-public-key"
}

variable "kp_filename" {
  type = string
  default = "jenkins-private-key"
}

variable "key_pair_file_permission" {
  type = string
  default = "400"
}

variable "tls_algorithm" {
  type = string
  default = "RSA"
}

variable "s3_name" {
  type = string
  default = "jenkins-bucket"
}

variable "aws_s3_block_public_access" {
  type = map(object({
    block_public_acls = bool
    block_public_policy = bool
    ignore_public_acls = bool
    restrict_public_buckets = bool
  }
  ))
  default = {
    "22" = {
      block_public_acls = true
      block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
    }
  }
}

variable "IAM_policy_name" {
  type = string
  default = "IAM-S3-test-policy."
}

variable "IAM_policy_description" {
  type = string
  default = "My test policy to grant read and write access to an S3 bucket."
}

variable "iam_instance_profile_name" {
  type = string
  default = "jenkins_instance_profile"
}

variable "iam_instance_profile_name" {
  type = string
  default = "jenkins-ec2-role"
}

