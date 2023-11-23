# Instructions

For a manual apply run:

0. Set your AWS credentials using you preffered method (e.g `export AWS_PROFILE=<your-profile-name>`)
1. `export TF_WORKSPACE=development`
2. `terraform init -backend-config=backend-"$TF_WORKSPACE".hcl`
3. `terraform plan -var-file=backend-"$TF_WORKSPACE".hcl`
4. `terraform apply -var-file=backend-"$TF_WORKSPACE".hcl`

If using task file run:

0. Set your AWS credentials using you preffered method (e.g `export AWS_PROFILE=<your-profile-name>`)
1. `task dev-init-ecr`
2. `task dev-plan-ecr`
3. `task dev-apply-ecr`
