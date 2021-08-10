#
# Makefile
#

#
# Values Generator
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




#############################################################################################################
###* Development
#############################################################################################################

# # #? Lint code  ==> make code_lint
code_lint:
	docker run --rm -e RUN_LOCAL=true -v /home/johnb/temp/opa_es:/tmp/lint ghcr.io/github/super-linter:slim-v4
	rm ../super-linter.log


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