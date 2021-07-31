#!/usr/bin/env bash

# Array variables
TF_VERSION=("1.0.0" "0.15.0" "0.14.0")
AZURERM_PROVIDER_VERSION=("2.69.0" "2.62.0" "2.41.0")

# Build images

for i in "${TF_VERSION[@]}"; do
    if [ $i == ${TF_VERSION[2]} ]; then
        echo "==> set azurerm_provider version to "${AZURERM_PROVIDER_VERSION[2]}" for Terraform version:"$i"..."
        AZURERM_PROVIDER="${AZURERM_PROVIDER_VERSION[2]}"
        echo $AZURERM_PROVIDER
        cat >.terraform.lock.hcl <<EOF
        # This file is maintained automatically by "terraform init".
        # Manual edits may be lost in future updates.
        
        provider "registry.terraform.io/hashicorp/azurerm" {
          version     = "${AZURERM_PROVIDER_VERSION[2]}"
          constraints = ">= 2.41.0"
        }
EOF
        docker build --build-arg TERRAFORM_VERSION=$i --build-arg AZURERM_PROVIDER=$AZURERM_PROVIDER -t "terraform_$i" .
        wait
        rm .terraform.lock.hcl
        wait

    elif [ $i == ${TF_VERSION[1]} ]; then
        echo "==> set azurerm_provider version to "${AZURERM_PROVIDER_VERSION[1]}" for Terraform version:"$i"..."
        AZURERM_PROVIDER="${AZURERM_PROVIDER_VERSION[1]}"
        echo $AZURERM_PROVIDER
        cat >.terraform.lock.hcl <<EOF
        # This file is maintained automatically by "terraform init".
        # Manual edits may be lost in future updates.
        
        provider "registry.terraform.io/hashicorp/azurerm" {
          version     = "${AZURERM_PROVIDER_VERSION[1]}"
          constraints = ">= 2.41.0"
        }
EOF
        docker build --build-arg TERRAFORM_VERSION=$i --build-arg AZURERM_PROVIDER=$AZURERM_PROVIDER -t "terraform_$i" .
        wait
        rm .terraform.lock.hcl
        wait

    else
        echo "==> set azurerm_provider version to "${AZURERM_PROVIDER_VERSION[0]}" for Terraform version:"$i"..."
        AZURERM_PROVIDER="${AZURERM_PROVIDER_VERSION[0]}"
        echo $AZURERM_PROVIDER
        cat >.terraform.lock.hcl <<EOF
        # This file is maintained automatically by "terraform init".
        # Manual edits may be lost in future updates.
        
        provider "registry.terraform.io/hashicorp/azurerm" {
          version     = "${AZURERM_PROVIDER_VERSION[0]}"
          constraints = ">= 2.41.0"
        }
EOF
        docker build --build-arg TERRAFORM_VERSION=$i --build-arg AZURERM_PROVIDER=$AZURERM_PROVIDER -t "terraform_$i" .
        wait
        rm .terraform.lock.hcl
        wait

    fi

done
