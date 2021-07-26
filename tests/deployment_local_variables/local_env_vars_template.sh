#!/usr/bin/env bash

set -e

#
# Shell Script Template
# - Set Azure CLI env vars
#

# # #* Update the env vars with your Azure subscription and SPN values

# # #* Rename the script: "local_env_vars_template.sh" ==> "local_env_vars.ignore.sh"
# # #* Renaming the script to: "local_env_vars.ignore.sh" will add it to the .gitignore list.

# # # Azure CLI env vars
ARM_TENANT_ID=""
ARM_CLIENT_ID=""
ARM_CLIENT_SECRET=""
ARM_SUBSCRIPTION_ID=""

export ARM_TENANT_ID
export ARM_CLIENT_ID
export ARM_CLIENT_SECRET
export ARM_SUBSCRIPTION_ID
