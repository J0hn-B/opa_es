#
# Makefile
#

#
# Values Generator
#

# # #* Variables
REPO := $(shell git rev-parse --show-toplevel)

# # # The name of the local image to be tested for security vulnerabilities and best practices <https://github.com/goodwithtech/dockle>
SECURITY_TEST_IMAGE_NAME := terraform

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




#############################################################################################################
###* Development
#############################################################################################################

# # #? Lint code  ==> make code_lint
code_lint:
	docker run --rm -e RUN_LOCAL=true -v $(REPO):/tmp/lint ghcr.io/github/super-linter:slim-v4
	rm ../super-linter.log


# # #? Verify docker image basic security after building locally  ==> make docker_security
docker_security:
	docker run --rm -it -e CI=true -v /var/run/docker.sock:/var/run/docker.sock wagoodman/dive:latest  $(SECURITY_TEST_IMAGE_NAME) 	
	docker run --rm -v /var/run/docker.sock:/var/run/docker.sock goodwithtech/dockle:v0.3.15 $(SECURITY_TEST_IMAGE_NAME)


# # #? Test the local docker image ==> make build_image
build_image:
	docker build --build-arg TERRAFORM_VERSION=1.0.3 --build-arg AZURERM_PROVIDER=2.70.0 -t terraform .
	docker run --name tf_test_result --env-file .env terraform
	docker container prune -f --filter "label=tfversion"
	docker image prune -f --filter "label=tfversion"


# # #? Inspect the local docker image ==> make inspect_image
inspect_image:
	docker inspect terraform | jq '.[].Config'


# # #? Run the local docker image ==> make run_image
run_image:
	docker run --name tf_test_result -it --rm terraform /bin/bash
