#
# Makefile
#

#
# Local Development
#

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
	docker build --build-arg TERRAFORM_VERSION=1.0.3 -t terraform .
	docker run -it --rm terraform /bin/bash
	docker image prune -f

docker_inspect:
	docker inspect terraform_0.14.0



#
# Azure Pipelines
#

docker_cloud_build:
	@echo "==> Test cloud runners..."
	pipelines/deployment.sh
	# docker run -it --rm terraform_0.14.0 /bin/bash
	# docker run -it --rm terraform_0.15.0 /bin/bash
	# docker run -it --rm terraform_1.0.0 /bin/bash

