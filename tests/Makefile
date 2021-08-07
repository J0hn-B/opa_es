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




#############################################################################################################
###* Development
#############################################################################################################
# # #? Test the local docker image ==> make build_image
build_image:
	docker build --build-arg TERRAFORM_VERSION=1.0.3 --build-arg AZURERM_PROVIDER=2.70.0 -t terraform .
	docker run --name tf_test_result --env-file .env terraform
	docker cp tf_test_result:tests/opa/test_results/. ./opa/test_results/
	docker container prune -f --filter "label=tf_version"
	docker image prune -f --filter "label=tf_version"
	sleep 5;
	rm -f ./opa/test_results/*.xml

# # #? Inspect the local docker image ==> make inspect_image
inspect_image:
	docker inspect terraform | jq '.[].Config'

# # #? Run the local docker image ==> make run_image
run_image:
	docker run --name tf_test_result -it --rm terraform /bin/bash