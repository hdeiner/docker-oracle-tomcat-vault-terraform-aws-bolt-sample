#!/usr/bin/env bash

figlet -w 120 -f standard "Terraform Oracle and Tomcat"

cd terraform-oracle-tomcat
terraform init
terraform apply -auto-approve
echo `terraform output oracle_dns | grep -o '".*"' | cut -d '"' -f2` > ../.oracle_dns
echo `terraform output tomcat_dns | grep -o '".*"' | cut -d '"' -f2` > ../.tomcat_dns
cd ..

export VAULT_DNS=$(echo `cat ./.vault_dns`)
echo "VAULT at "$VAULT_DNS
export VAULT_TOKEN=$(echo `cat ./.vault_initial_root_token`)
echo "VAULT_TOKEN is "$VAULT_TOKEN

export ORACLE=$(echo `cat ./.oracle_dns`)
export TOMCAT=$(echo `cat ./.tomcat_dns`)
echo "ORACLE at "$ORACLE
echo "TOMCAT at "$TOMCAT

echo `date +%Y%m%d%H%M%S` > ./.runbatch
export RUNBATCH=$(echo `cat ./.runbatch`)

vault login -address="http://$VAULT_DNS:8200" $VAULT_TOKEN
vault secrets enable -address="http://$VAULT_DNS:8200" -version=2 -path=oracle kv
vault secrets enable -address="http://$VAULT_DNS:8200" -version=2 -path=tomcat kv

vault kv put -address="http://$VAULT_DNS:8200" oracle/dev/$RUNBATCH/dns dns=$ORACLE
vault kv put -address="http://$VAULT_DNS:8200" tomcat/dev/$RUNBATCH/dns dns=$TOMCAT
