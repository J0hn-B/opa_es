# Test suite for CAF Terraform Module

## Structure

- Generate local values process remains the same

- The "remote test process" runs inside a container.

- `deployment` and `opa` directories have zero changes.

- **`scripts`** directory contains only the scripts for generating local values.

- **`pipelines`** directory contains `entrypoint.sh` and the `terraform_env_vars.sh`. Both of them running inside the container.

- `entrypoint.sh` holds the logic for terraform plan and opa tests execution, `terraform_env_vars.sh` sets and exports the terraform module(s) vars

Docker for desktop is required.

### How to

1. Create or update the terraform files on `deployment` dir.

2. Update the terraform variables and their exports in `pipelines/terraform_env_vars.sh`

3. All the processes are available through `make`. From inside `tests/` dir run:

   - `make local` ==> Generate values for testing automation

   - `make code_lint` ==> Lint code locally before pushing on repo.

     Update the path in makefile by replacing `/home/johnb/temp/opa_es` with your own path.

   - Create a `.env` file inside `tests/` dir and add the Azure subscription details. `.gitignore` will ignore the `.env`file.

     - The `.env` file will look like this:

       ```docker

        ARM_TENANT_ID=xxxxx-xxx-xxxxxxx-xxxxxxxx-xxxxx
        ARM_CLIENT_ID=xxxxx-xxx-xxxxxxx-xxxxxxxx-xxxxx
        ARM_CLIENT_SECRET=xxxxx-xxx-xxxxxxx-xxxxxxxx-xxxxx
        ARM_SUBSCRIPTION_ID=xxxxx-xxx-xxxxxxx-xxxxxxxx-xxxxx
       ```

       - `make build_image` to build an image locally and verify the build and run success.

   - `make inspect_image` ==> Inspect the local docker image

   - `make run_image` ==> Run the docker image locally and access the container's cmd.

### Azure Pipelines

Using Microsoft-hosted agents, we build and run the container image on the host agent.

The tests `.xml` files are exported to the host agent and published as pipelines test results.

1. Create a new build pipeline using the `azure-pipelines.yaml` on `tests/` dir

2. Add the variables in the pipeline:

   ```azure-pipelines
   TENANT_ID=xxxxx-xxx-xxxxxxx-xxxxxxxx-xxxxx
   CLIENT_ID=xxxxx-xxx-xxxxxxx-xxxxxxxx-xxxxx
   CLIENT_SECRET=xxxxx-xxx-xxxxxxx-xxxxxxxx-xxxxx
   SUBSCRIPTION_ID=xxxxx-xxx-xxxxxxx-xxxxxxxx-xxxxx
   ```

   ![image](https://user-images.githubusercontent.com/40946247/129191753-2744a560-eafc-4689-a1fd-f41e62b5a756.png)

3. Set the Terraform and Azure Provider version:

   ![image](https://user-images.githubusercontent.com/40946247/129192194-8e985e7a-b847-4ac6-a759-abefac94fce9.png)

4. Check the results:

   ![image](https://user-images.githubusercontent.com/40946247/129193280-858c35bd-1ca7-405d-b1ec-7b798f3d127a.png)

   ![image](https://user-images.githubusercontent.com/40946247/129193383-4f0e4d1c-00aa-4222-8188-3f722a08ba24.png)
