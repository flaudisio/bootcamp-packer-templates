packer {
  required_version = ">= 1.7.0"

  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">= 1.2.1"
    }
  }
}
