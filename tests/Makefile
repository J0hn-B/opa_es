#
# Makefile
#

#
# Local Development
#


local: opa-install \
opa-values-generator \
docker_build


# # #* Targets
opa-install:
	@echo "==> Prepare local environment..."
	cd scripts; ./opa-install.sh

opa-values-generator:
	@echo "==> Run tests and generate pipeline testing values..."
	cd scripts; ./opa-values-generator.sh


docker_build:
	docker build --build-arg TERRAFORM_VERSION=1.0.3 --build-arg AZURERM_PROVIDER=2.70.0 -t terraform .
	docker run -it --rm terraform 
	docker image prune -f

docker_inspect:
	docker inspect terraform_0.14.0



#
# Azure Pipelines
#


# # #* Targets
cloud_build:
	@echo "==> Test cloud runners..."
	docker build --build-arg TERRAFORM_VERSION=1.0.1 --build-arg AZURERM_PROVIDER=2.41.0 -t terraform_1.0.1 .
	docker inspect terraform_1.0.1 | jq '.[].Config.Env'

cloud_run:
	docker run -it --rm terraform_1.0.1
	
