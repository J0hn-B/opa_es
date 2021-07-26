#
# Makefile
#

# Azure Pipelines

# # #* Targets execution order
all: opa-install \
opa-run-tests


# # #* Targets
opa-install:
	@echo "==> Running script..."
	./tests/scripts/opa-install.sh

opa-run-tests:
	@echo "==> Running script..."
	./tests/scripts/opa-run-tests.sh


docker_build:
	#docker scan --file tests/Dockerfile terraform
	cd tests/ && docker build -t terraform .
	docker run -it --rm terraform /bin/bash
	docker image prune -f
    #docker builder prune -a