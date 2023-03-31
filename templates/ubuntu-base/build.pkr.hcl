# ------------------------------------------------------------------------------
# LOCALS
# ------------------------------------------------------------------------------

locals {
  datetime = formatdate("YYYYMMDD-hhmmss", timestamp())

  image_name_prefix = "ubuntu-base-${var.ubuntu_version}"
  image_description = "Base image for Ubuntu ${var.ubuntu_version}"

  ami_name_amd64 = format("%s-%s-amd64", local.image_name_prefix, local.datetime)
  ami_name_arm64 = format("%s-%s-arm64", local.image_name_prefix, local.datetime)

  build_run_tags = {
    Name       = "packer-builder-for-${local.image_name_prefix}"
    created-by = "packer"
  }

  build_common_tags = {
    created-by              = "packer"
    "packer:packer-version" = packer.version
  }
}

# ------------------------------------------------------------------------------
# DATA SOURCES
# ------------------------------------------------------------------------------

data "amazon-ami" "ubuntu-amd64" {
  region      = var.region
  most_recent = true
  owners      = var.ami_owners

  filters = merge(
    var.ami_filters,
    {
      name         = "ubuntu-minimal/images/*ubuntu-*-${var.ubuntu_version}-*-minimal-*"
      architecture = "x86_64"
    }
  )
}

data "amazon-ami" "ubuntu-arm64" {
  region      = var.region
  most_recent = true
  owners      = var.ami_owners

  filters = merge(
    var.ami_filters,
    {
      name         = "ubuntu-minimal/images/*ubuntu-*-${var.ubuntu_version}-*-minimal-*"
      architecture = "arm64"
    }
  )
}

# ------------------------------------------------------------------------------
# SOURCES
# ------------------------------------------------------------------------------

source "amazon-ebs" "ubuntu-common" {
  region          = var.region
  ami_description = local.image_description
  ssh_username    = "ubuntu"
  run_tags        = local.build_run_tags
  run_volume_tags = local.build_run_tags
}

# ------------------------------------------------------------------------------
# BUILDS
# ------------------------------------------------------------------------------

build {
  source "source.amazon-ebs.ubuntu-common" {
    name = "amd64"

    source_ami    = data.amazon-ami.ubuntu-amd64.id
    ami_name      = local.ami_name_amd64
    instance_type = var.instance_type_amd64

    tags = merge(
      local.build_common_tags,
      {
        Name                      = local.ami_name_amd64
        "packer:source-ami-id"    = data.amazon-ami.ubuntu-amd64.id
        "packer:source-ami-name"  = data.amazon-ami.ubuntu-amd64.name
        "packer:source-ami-owner" = data.amazon-ami.ubuntu-amd64.owner
      }
    )
  }

  source "source.amazon-ebs.ubuntu-common" {
    name = "arm64"

    source_ami    = data.amazon-ami.ubuntu-arm64.id
    ami_name      = local.ami_name_arm64
    instance_type = var.instance_type_arm64

    tags = merge(
      local.build_common_tags,
      {
        Name                      = local.ami_name_arm64
        "packer:source-ami-id"    = data.amazon-ami.ubuntu-arm64.id
        "packer:source-ami-name"  = data.amazon-ami.ubuntu-arm64.name
        "packer:source-ami-owner" = data.amazon-ami.ubuntu-arm64.owner
      }
    )
  }

  provisioner "shell" {
    scripts = [
      "../_scripts/wait-cloud-init.sh",
      "../_scripts/apt-upgrade.sh",
      "../_scripts/setup-ansible.sh",
    ]
  }
}
