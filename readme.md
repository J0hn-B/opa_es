# Test suite for CAF Terraform Module

The CAF Terraform Module is able to deploy different groups of resources depending on the selected options. The module also requires a minimum azurerm provider version of `2.41.0` and it is compatible with a selection of Terraform versions, as described in the module's official wiki page.

[Open Policy Agent](https://www.openpolicyagent.org/docs/latest) is an open source, general-purpose policy engine that unifies policy enforcement across the stack.

We are using Open Policy Agent to test and validate the hcl code generates the expected values and also to verify that recent code changes haven't altered existing functionality.

## Resources

With Open Policy Agent being the policy engine, a set of utilities is required to complete the testing process:

- [jq](https://stedolan.github.io/jq/), a json parser
- [yq](https://github.com/mikefarah/yq), a yaml parser
- [yamllint](https://yamllint.readthedocs.io/en/stable/), a yaml linter
- [Conftest](https://www.conftest.dev/), automation utility for Open Policy Agent

## How it works

### Workstation

We are using `terraform plan` to generate a plan and we convert that plan to a \*.json file. We then extract the module(s) `planned_values` and we validate they are equal to the plan's `changed_values`.

### Usage

**From your workstation:**

1. Update the terraform files in `tests/deployment/` directory.

2. Verify `tests/deployment/variables.tf` declared variables have been set as input variables in `opa-values-generator.sh` or `.ps1` script.

![3](https://user-images.githubusercontent.com/40946247/127203542-62670f7d-fbca-4be7-81d7-526c57896852.png)

**Option 1:**

From within `tests/` directory.

`make`

**Option 2:**

Navigate to the modules `tests` directory.

- create a new dir: `mkdir deployment_2 && cd deployment_2`

- create a new file: `touch main.tf`

- Copy paste the terraform code from the [Deploy-Default-Configuration](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Deploy-Default-Configuration) example in your `deployment_2/main.tf`

- From the `deployment` directory, copy paste the `variables.tf` file in your `deployment_2` directory.

- In your `tests/scripts/opa-values-generator.sh`, update the path in line 26:
  **MODULE_PATH="../deployment_2"**

- From within `tests/` directory: `make`

- Delete dir `deployment_2`

- In your `tests/scripts/opa-values-generator.sh`, update the path back to the original value in line 26:
  **MODULE_PATH="../deployment"**
