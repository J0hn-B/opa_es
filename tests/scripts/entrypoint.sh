#!/usr/bin/env bash

set -e

#
# Shell Script
# - Test Terraform Deployment
#

source deployment_local_variables/local_env_vars.sh

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

echo "==> Initialize Terraform configuration files..."
terraform init

echo "==>  Create a Terraform execution plan..."
terraform plan -out="$TERRAFORM_VERSION".plan

echo "==> Converting plan to *.json..."
terraform show -json "$TERRAFORM_VERSION".plan >"$TERRAFORM_VERSION".json

echo "==> Removing the original plan..."
rm "$TERRAFORM_VERSION".plan

# # #* OPA run tests
TF_ROOT_ID_1=root-id-1 ##"${RANDOM}-es"
TF_ROOT_ID_2=root-id-2 ##"${RANDOM}-es"
TF_ROOT_ID_3=root-id-3 ## "${RANDOM}-es"

TF_PLAN_JSON="$TERRAFORM_VERSION".json

# # # Store data temporarily
TEMP_FILE_01=$(mktemp).json
TEMP_FILE_02=$(mktemp).json

# # # Update the planned_values.json with the latest parameters
echo "==> Update planned values..."
#cd "tests/deployment" # # # "$PIPELINE_WORKSPACE/s/tests/deployment"
jq '(.. | strings) |= gsub("root-id-1"; "'"$TF_ROOT_ID_1"'")' planned_values.json >"$TEMP_FILE_01"
jq '(.. | strings) |= gsub("root-id-2"; "'"$TF_ROOT_ID_2"'")' "$TEMP_FILE_01" >"$TEMP_FILE_02"
jq '(.. | strings) |= gsub("root-id-3"; "'"$TF_ROOT_ID_3"'")' "$TEMP_FILE_02" >"$TEMP_FILE_01"
jq '(.. | strings) |= gsub("root-name"; "ES-'"$TF_VERSION"'-'"$TF_AZ_VERSION"'")' "$TEMP_FILE_01" >"$TEMP_FILE_02"
jq '(.. | strings) |= gsub("eastus"; "eastus")' "$TEMP_FILE_02" >"$TF_PLAN_JSON"_updated_planned_values.json

echo "==> Module Location - $DEFAULT_LOCATION"
echo "==> Azure {TF_ROOT_ID_1} - ${TF_ROOT_ID_1}"
echo "==> Azure TF_ROOT_ID_1 - $TF_ROOT_ID_1"

wait

echo "==> Converting to yaml..."
yq <"$TF_PLAN_JSON"_updated_planned_values.json e -P - >../opa/policy/"$TF_PLAN_JSON"_updated_planned_values.yml

wait

echo "==> Check yaml for errors..."
yamllint -d relaxed ../opa/policy/"$TF_PLAN_JSON"_updated_planned_values.yml

cat "$TERRAFORM_VERSION".json ###!!!!!

echo "==> Running conftest..."
echo
echo "==> Testing management_groups..."
conftest test "$TF_PLAN_JSON" -p ../opa/policy/management_groups.rego -d ../opa/policy/"$TF_PLAN_JSON"_updated_planned_values.yml
echo
echo "==> Testing role_definitions..."
conftest test "$TF_PLAN_JSON" -p ../opa/policy/role_definitions.rego -d ../opa/policy/"$TF_PLAN_JSON"_updated_planned_values.yml
echo
echo "==> Testing role_assignments..."
conftest test "$TF_PLAN_JSON" -p ../opa/policy/role_assignments.rego -d ../opa/policy/"$TF_PLAN_JSON"_updated_planned_values.yml
echo
echo "==> Testing policy_set_definitions..."
conftest test "$TF_PLAN_JSON" -p ../opa/policy/policy_set_definitions.rego -d ../opa/policy/"$TF_PLAN_JSON"_updated_planned_values.yml
echo
echo "==> Testing policy_definitions..."
conftest test "$TF_PLAN_JSON" -p ../opa/policy/policy_definitions.rego -d ../opa/policy/"$TF_PLAN_JSON"_updated_planned_values.yml
echo
echo "==> Testing policy_assignments..."
conftest test "$TF_PLAN_JSON" -p ../opa/policy/policy_assignments.rego -d ../opa/policy/"$TF_PLAN_JSON"_updated_planned_values.yml
