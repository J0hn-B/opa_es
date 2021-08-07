#
# Makefile
#

#
# Local Development
#

# # #? Generate values for testing automation ==> make local

local: opa-install \
opa-values-generator 



# # #* Targets
opa-install:
	@echo "==> Prepare local environment..."
	cd scripts; ./opa-install.sh

opa-values-generator:
	@echo "==> Run tests and generate pipeline testing values..."
	cd scripts; ./opa-values-generator.sh

# # #? Test the local docker image ==> make build_image
build_image:
	docker build --build-arg TERRAFORM_VERSION=1.0.3 --build-arg AZURERM_PROVIDER=2.70.0 -t terraform .
	docker run --env-file .env terraform
	docker container prune -f --filter "label=tf_version"
	docker image prune -f --filter "label=tf_version"

# # #? Inspect the local docker image ==> make inspect_image
inspect_image:
	docker inspect terraform | jq '.[].Config'


