# Packer Templates

[Packer](https://developer.hashicorp.com/packer/docs/intro) templates to create cloud images.

## Requirements

- Packer >= 1.7.0

## Usage

Clone the repository:

```console
$ git clone https://github.com/flaudisio/bootcamp-packer-templates.git
$ cd packer-templates/
```

Choose a template and set credentials according to its builders:

```console
$ cd templates/ubuntu-base/
$ export AWS_ACCESS_KEY_ID=<ACCESS_KEY>
$ export AWS_SECRET_ACCESS_KEY=<SECRET_KEY>
```

Validate and build the images:

```console
$ packer validate .
$ packer build .
```

If applicable, use `-only` to build specific images:

```console
$ packer build -only amazon-ebs.amd64 .
```

## Conventions

- Packer manifest filenames end with `.pkr.hcl`

- Templates are organized using the following files:
  - `versions.pkr.hcl`: required Packer version and plugins (if applicable)
  - `variables.pkr.hcl`: template variables
  - `build.pkr.hcl`: locals, data sources, sources and builds
