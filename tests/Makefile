#
# Makefile
#

# Azure Pipelines

# # #* Targets execution order
local_development: opa-install \
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
	docker build -t terraform .
	docker run -it --rm terraform /bin/bash
	docker image prune -f
