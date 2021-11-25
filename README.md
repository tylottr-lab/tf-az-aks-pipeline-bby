# Terraform Module - CHANGE_ME

#### Table of Contents

1. [Usage](#usage)
2. [Requirements](#requirements)
3. [Inputs](#inputs)
4. [Outputs](#outputs)
5. [Resources](#resources)
6. [Examples](#examples)

## Usage

This document will describe what the module is for and what is contained in it. It will be generated using [terraform-docs](https://terraform-docs.io/) which is configured to append to the existing README.md file.

Ensure that you have [pre-commit](https://pre-commit.com/) installed to make the most of this template, and use `pre-commit run -a` after adding files. See [.pre-commit-config.yaml](.pre-commit-config.yaml) for information on the dependencies needed, including `terraform-docs`, `tflint` and `tfsec`.

Things to update:
- README.md header
- README.md header content - description of module and its purpose
- Update [terraform.tf](terraform.tf) required_versions

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |

## Inputs

No inputs.

## Outputs

No outputs.

## Resources

No resources.

## Examples

```hcl
module "example" {
  source = "../"

  // Module Inputs

}
```
<!-- END_TF_DOCS -->
