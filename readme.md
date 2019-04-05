This project demonstrates a way to build and test on AWS between an Oracle database and a Tomcat application incorporating Vault to hold configuration information and secrets securely.

We add the complexity of how to distribute secrets and configuration to the deployed application as well.  We will also explore the use of Puppet Bolt to do the provisioning, which simplifies the Terraforming and provisioning process, as it uses Terraform with the single responsibility for managing instances and gives us the freedom to use another highly cohesive tool, Bolt, to do the provisioning.

This project explores a "halfway" solution to configuration of endpoints and configuration in general.  We could redesign our applications to make redis querries as they run to get what they need.  However, many applications already use "property" files.  We will build the property files from redis-cli queries, construct the property files, and put them into the containers which are calling upon them.  Again, this is not THE solution, but an easy to follow example to get you started thinking about how redis can be used.

```bash
./build_and_test_1_terraform_vault.sh
```
1. Use terraform to create an appropriate AWS EC2 instance.

```bash
./build_and_test_2_provision_vault.sh
```
1. Use bolt to upload and execute the provisioning script (written in bash) on the Vault server.

```bash
./build_and_test_3_terraform_oracle_and_tomcat.sh
```
1. Use terraform to create appropriate AWS EC2 instances for the Oracle and Tomcat servers.
2. Introduces a better use of Vault.  I assume that there is a singlton instance in use for the organization (although in this project, I build that instance).  But for our testing purposes, we want a RUNBATCH of related servers (so I use a formatted timestamp for uniqueness).  Now, store the EC2 DNS insyance for Oracle at $USER.$RUNBATCH.oracle.dns (and the same for Tomcat).  Now, we are using the environment, runbatch, and key to retrieve the value from.

```bash
./build_and_test_4_provision_oracle_and_tomcat.sh
```
1. Use bolt to upload and execute the provisioning script (written in bash) on the Oracle server.
2. Save the Oracle user and password just created into Vault, using the same appropriate key system.
3. Built a liquibae.properties file from Vault entries.
4. Run Liquibase locally and create the database in the EC2 instance for testing.
5. Compile the war that we want to test on Tomcat.
6. Build the oracleConfig.properties file used by our war from Vault configuration information.  The war and this file will need to be sent to the EC2 Tomcat server and then deployed in that environment. 
7. Provision the Tomcat server.  This consists of uploading the provisoning script, the war, and the properties file and then remotely running the provisioning script.

```bash
./build_and_test_5_run_tests.sh
```
1. Run a smoke test to make sure everything is wired together correctly.
2. Build the rest_webservice.properties file used by our Cucumber tests from redis configuration information. 
3. Run the tests (Cucumber for Java used).

```bash
./build_and_test_6_teardown.sh
```
1. Use terraform to destroy the tomcat, oracle, and vault infrastructure.
2. Delete the temporary files we created during the run that facilitated the integration of components.
