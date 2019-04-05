#!/usr/bin/env bash

figlet -w 120 -f standard "Terraform Vault"

cd terraform-vault
terraform init
terraform apply -auto-approve
echo `terraform output vault_dns` > ../.vault_dns
cd ..
