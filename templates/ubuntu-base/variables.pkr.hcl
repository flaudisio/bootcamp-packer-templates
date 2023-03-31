variable "ubuntu_version" {
  type    = string
  default = "22.04"
}

variable "ami_owners" {
  type = list(string)
  # Canonical account ID
  # Ref: https://ubuntu.com/server/docs/cloud-images/amazon-ec2
  default = ["099720109477"]
}

variable "ami_filters" {
  type = map(string)
  default = {
    root-device-type    = "ebs"
    virtualization-type = "hvm"
    state               = "available"
  }
}

variable "instance_type_amd64" {
  type    = string
  default = "t3a.small"
}

variable "instance_type_arm64" {
  type    = string
  default = "t4g.small"
}

variable "region" {
  type    = string
  default = "us-east-1"
}
