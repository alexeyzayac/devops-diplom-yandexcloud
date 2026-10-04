TF_DIR_CS = 00_cloud_setup
TF_DIR_MAIN = 01_main

.PHONY: fmt up down up_cloud_setup down_cloud_setup up_main down_main

fmt:
	terraform fmt -recursive terraform/

up_cloud_setup:
	cd $(TF_DIR_CS) && terraform init -upgrade
	cd $(TF_DIR_CS) && terraform validate
	cd $(TF_DIR_CS) && terraform plan
	cd $(TF_DIR_CS) && terraform apply --auto-approve

down_cloud_setup:
	cd $(TF_DIR_CS) && terraform destroy --auto-approve
	rm -rf $(TF_DIR_CS)/.terraform
	rm -f  $(TF_DIR_CS)/.terraform.lock.hcl
	rm -f  $(TF_DIR_CS)/terraform.tfstate
	rm -f  $(TF_DIR_CS)/terraform.tfstate.backup

up_main:
	cd $(TF_DIR_MAIN) && terraform init -reconfigure -upgrade -backend-config=../secret/backend.hcl
	cd $(TF_DIR_MAIN) && terraform validate
	cd $(TF_DIR_MAIN) && terraform plan
	cd $(TF_DIR_MAIN) && terraform apply --auto-approve

down_main:
	cd $(TF_DIR_MAIN) && terraform destroy --auto-approve
	rm -rf $(TF_DIR_MAIN)/.terraform
	rm -f  $(TF_DIR_MAIN)/.terraform.lock.hcl
	rm -f  $(TF_DIR_MAIN)/terraform.tfstate
	rm -f  $(TF_DIR_MAIN)/terraform.tfstate.backup

up: up_cloud_setup up_main
down: down_main down_cloud_setup