
# # # Setup build arguments with default versions
ARG TERRAFORM_VERSION=1.0.3
ARG CONFTEST_VERSION=0.24.0
ARG YQ_VERSION=v4.9.3

#TODO: Add azurerm provider version

# # # Install packages
FROM mcr.microsoft.com/azure-cli

ARG TERRAFORM_VERSION
ARG CONFTEST_VERSION
ARG YQ_VERSION

ENV TERRAFORM_VERSION=$TERRAFORM_VERSION

RUN apk add --no-cache --virtual  prepare_container jq yamllint

RUN wget https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64 -O /usr/bin/yq && \
    chmod +x /usr/bin/yq

RUN  wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && mv terraform /usr/bin/terraform && rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

RUN wget https://github.com/open-policy-agent/conftest/releases/download/v${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz && \
    tar xzf conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz && mv conftest /usr/local/bin && rm -rf conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz


# # # Copy files
WORKDIR  /tests

COPY deployment/ ./deployment

COPY opa/ ./opa

COPY scripts/ ./scripts

COPY deployment_local_variables/ ./deployment_local_variables

# RUN ["chmod", "+x", "/tests/scripts/entrypoint.sh"]

# ENTRYPOINT ["/tests/scripts/entrypoint.sh"]
