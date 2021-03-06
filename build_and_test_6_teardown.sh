#!/usr/bin/env bash

figlet -w 120 -f standard "Teardown Everything"

cd terraform-vault
terraform destroy -auto-approve
cd ..

cd terraform-oracle-tomcat
terraform destroy -auto-approve
cd ..

rm ./.vault_dns ./.vault_initial_root_token ./.oracle_dns ./.tomcat_dns ./.runbatch liquibase.properties oracleConfig.properties rest_webservice.properties