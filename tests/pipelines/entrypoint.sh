#!/usr/bin/env bash

set -e

#
# Shell Script
# - Test Terraform Deployment
#
# # #

source pipelines/terraform_env_vars.sh

# # #* Azure CLI login
echo "==> Authenticating cli..."
az login \
  --service-principal \
  --tenant "$ARM_TENANT_ID" \
  --username "$ARM_CLIENT_ID" \
  --password "$ARM_CLIENT_SECRET" \
  --query [?isDefault]

# # #* Terraform Init and Plan
echo "==> Format and style Terraform configuration files..."
cd deployment
terraform fmt -diff -check -recursive

echo "==> Update the azurerm provider version..."
cat >.terraform.lock.hcl <<EOF
        # This file is maintained automatically by "terraform init".
        # Manual edits may be lost in future updates.
        
        provider "registry.terraform.io/hashicorp/azurerm" {
          version     = "${AZURERM_PROVIDER}"
          constraints = ">= 2.41.0"
        }
EOF

echo "==> Initialize Terraform configuration files..."
terraform init

echo "==>  Create a Terraform execution plan..."
terraform plan -out="$TERRAFORM_VERSION".plan

echo "==> Converting plan to *.json..."
terraform show -json "$TERRAFORM_VERSION".plan >"$TERRAFORM_VERSION".json

echo "==> Removing the original plan..."
rm "$TERRAFORM_VERSION".plan

# # #* OPA run tests

TF_PLAN_JSON="$TERRAFORM_VERSION".json

# # # Store data temporarily
TEMP_FILE_01=$(mktemp).json
TEMP_FILE_02=$(mktemp).json

# # # Update the planned_values.json with the latest parameters
echo "==> Update planned values..."
#cd "deployment/"
pwd
jq '(.. | strings) |= gsub("root-id-1"; "'"$TF_VAR_root_id_1"'")' planned_values.json >"$TEMP_FILE_01"
jq '(.. | strings) |= gsub("root-id-2"; "'"$TF_VAR_root_id_2"'")' "$TEMP_FILE_01" >"$TEMP_FILE_02"
jq '(.. | strings) |= gsub("root-id-3"; "'"$TF_VAR_root_id_3"'")' "$TEMP_FILE_02" >"$TEMP_FILE_01"
jq '(.. | strings) |= gsub("root-name"; "'"$TF_VAR_root_name"'")' "$TEMP_FILE_01" >"$TEMP_FILE_02"
jq '(.. | strings) |= gsub("eastus"; "'"$TF_VAR_location"'")' "$TEMP_FILE_02" >"$TF_PLAN_JSON"_updated_planned_values.json

echo "==> Converting to yaml..."
yq <"$TF_PLAN_JSON"_updated_planned_values.json e -P - >../opa/policy/"$TF_PLAN_JSON"_updated_planned_values.yml

wait

echo "==> Check "$TF_PLAN_JSON"_updated_planned_values.yml for errors..."
yamllint -d "{extends: relaxed, rules: {line-length: {max: 5000, allow-non-breakable-words: true, allow-non-breakable-inline-mappings: true}}}" ../opa/policy/"$TF_PLAN_JSON"_updated_planned_values.yml

echo "==> Running conftest..."
echo
echo "==> Testing management_groups..."
conftest test "$TF_PLAN_JSON" -p ../opa/policy/management_groups.rego -d ../opa/policy/"$TF_PLAN_JSON"_updated_planned_values.yml -o junit >tests/opa/test_results/management_groups.xml
echo
echo "==> Testing role_definitions..."
conftest test "$TF_PLAN_JSON" -p ../opa/policy/role_definitions.rego -d ../opa/policy/"$TF_PLAN_JSON"_updated_planned_values.yml -o junit >../opa/test_results/role_definitions.xml
echo
echo "==> Testing role_assignments..."
conftest test "$TF_PLAN_JSON" -p ../opa/policy/role_assignments.rego -d ../opa/policy/"$TF_PLAN_JSON"_updated_planned_values.yml -o junit >../opa/test_results/role_assignments.xml
echo
echo "==> Testing policy_set_definitions..."
conftest test "$TF_PLAN_JSON" -p ../opa/policy/policy_set_definitions.rego -d ../opa/policy/"$TF_PLAN_JSON"_updated_planned_values.yml -o junit >../opa/test_results/policy_set_definitions.xml
echo
echo "==> Testing policy_definitions..."
conftest test "$TF_PLAN_JSON" -p ../opa/policy/policy_definitions.rego -d ../opa/policy/"$TF_PLAN_JSON"_updated_planned_values.yml -o junit >../opa/test_results/policy_definitions.xml
echo
echo "==> Testing policy_assignments..."
conftest test "$TF_PLAN_JSON" -p ../opa/policy/policy_assignments.rego -d ../opa/policy/"$TF_PLAN_JSON"_updated_planned_values.yml -o junit >../opa/test_results/policy_assignments.xml
