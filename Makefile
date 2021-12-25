.PHONY: setup_state_bucket_and_dynamodb_table check_tenant check_environment

terraform_config_dir=$(shell pwd)
$(eval backend_config_file_path="$(terraform_config_dir)/base-infra/config/a-b-backend.hcl")

###########################
# Method execute manually
###########################
setup_state_bucket_and_dynamodb_table: check_a check_b
	cd ./base-infra/state-bucket && \
	terraform init -var="a=$(a)" -var="b=$(b)" -backend-config="path=tf-states/terraform.tfstate" -reconfigure && \
	terraform plan -var="a=$(a)" -var="b=$(b)" -out=terraform.tfplan && \
	terraform apply terraform.tfplan

################################
# Method execute automatically
################################
prepare_base_infra:
	cd ./base-infra && \
	terraform init -var="a=$(a)" -var="b=$(b)" -backend-config="dynamodb_table=a-b-tfstate-db" -backend-config="encrypt=true" -backend-config="key=tfstate-bucket" -backend-config="bucket=a-b-tfstate-bucket" -reconfigure && \
	terraform plan -var="a=$(a)" -var="b=$(b)" -out=terraform.tfplan

apply_base_infra:
	cd ./base-infra && \
	terraform init -var="a=$(a)" -var="b=$(b)" -backend-config="dynamodb_table=a-b-tfstate-db" -backend-config="encrypt=true" -backend-config="key=tfstate-bucket" -backend-config="bucket=a-b-tfstate-bucket" -reconfigure && \
	terraform apply terraform.tfplan

prepare_base_infra1:
	cd ./base-infra && \
	terraform init -var="a=$(a)" -var="b=$(b)" -backend-config="$(backend_config_file_path)" -reconfigure && \
	terraform plan -var="a=$(a)" -var="b=$(b)" -out=terraform.tfplan

apply_base_infra1:
	cd ./base-infra && \
	terraform init -var="a=$(a)" -var="b=$(b)" -backend-config="$(backend_config_file_path)" -reconfigure && \
	terraform apply terraform.tfplan

setup_api_gateway_and_lambda:
	cd ./base-infra/api-gateway && \
	terraform init -reconfigure && \
	terraform plan -out=terraform.tfplan && \
	terraform apply terraform.tfplan

setup_ecr:
	cd ./base-infra/ecr && \
	terraform init -reconfigure && \
	terraform plan -out=terraform.tfplan && \
	terraform apply terraform.tfplan

check_a:
ifndef a
	$(error a is undefined)
endif
check_b:
ifndef b
	$(error b is undefined)
endif
