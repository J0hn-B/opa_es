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

The test suite is used to verify the values generated from the module(s) between different terraform versions and different terraform providers.

- Running locally the first time, a `terraform plan` is generated using the terraform version and azurerm provider of your environment. A `planned_values` file containing data which will be used as `--data` input when testing, is created.

  - Using `planned_values` file, tests are executed locally and expected to be successful.

    - The, locally generated, `planned_values` file is saved and after pushed in the repo, used as Conftest `--data` input against different terraform versions and different terraform providers on the remote pipeline runners.

### Workstation

1. The `opa-values-generator.sh` or `.ps1` script will read the `.tf` files in the deployment directory and generate a plan with `terraform plan`.

2. Will convert that plan to a \*.json file. Next, will extract the module(s) `planned_values` and validate they are equal to the plan's `changed_values`. A file `planned_values.json` is generated and stored in the `deployment` directory.

3. Using the `planned_values` all the tests are executed locally to verify the values and Open Policy Agent rules behavior.

4. The `planned_values.json` is saved and added to the `deployment`. Will be used later from the automation pipeline runners.

### Usage

**From your workstation:**

1. Update the terraform files in `tests/deployment/` directory.

2. Verify `tests/deployment/variables.tf` declared variables have been set as input variables in `opa-values-generator.sh` or `.ps1` script.

![3](https://user-images.githubusercontent.com/40946247/127203542-62670f7d-fbca-4be7-81d7-526c57896852.png)

**Option 1:**

From within `tests/` directory:

`make`

A `planned_values.json` is added in your deployment directory.

Will be used later in the automation pipelines.

![image](https://user-images.githubusercontent.com/40946247/127209046-0c667eca-b38d-453a-b724-7da49779689b.png)

**Option 2:**

Navigate to the modules `tests` directory.

- create a new dir: `mkdir deployment_2 && cd deployment_2`

- create a new file: `touch main.tf`

- Copy paste the terraform code from the [Deploy-Default-Configuration](https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BExamples%5D-Deploy-Default-Configuration) example in your `deployment_2/main.tf`

- From the `deployment` directory, copy paste the `variables.tf` file in your `deployment_2` directory.

- In your `tests/scripts/opa-values-generator.sh`, update the path in line 26:
  **MODULE_PATH="../deployment_2"**

- From within `tests/` directory:

  - `make`

- Delete dir `deployment_2`

- In your `tests/scripts/opa-values-generator.sh`, update the path back to the original value in line 26:
  **MODULE_PATH="../deployment"**
