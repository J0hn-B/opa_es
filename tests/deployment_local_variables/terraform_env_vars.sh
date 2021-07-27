#!/usr/bin/env bash

set -e

#
# Shell Script
# - Set Terraform env vars
#

# # # Set terraform environement vars
TF_VAR_root_id_1="myorg-1"
TF_VAR_root_id_2="myorg-2"
TF_VAR_root_id_3="myorg-3"
TF_VAR_root_name="MyOrganization"
TF_VAR_location="uksouth"

# # # Linter-check SC2034: export if used externally
# # # Export terraform environement vars
export TF_VAR_root_id_1
export TF_VAR_root_id_2
export TF_VAR_root_id_3
export TF_VAR_root_name
export TF_VAR_location
