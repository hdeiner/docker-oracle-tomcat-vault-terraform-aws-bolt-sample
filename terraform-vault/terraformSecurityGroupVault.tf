resource "aws_security_group" "vault" {
  name        = "docker-oracle-vault-tomcat-terraform-aws-bolt-sample-vault"
  description = "docker-oracle-tomcat-vault-terraform-aws-bolt-sample Vault Access"
  ingress {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
  ingress {
    protocol  = "tcp"
    from_port = 8200
    to_port   = 8200
    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
  tags = {
    Name = "docker-oracle-tomcat-vault-terraform-aws-bolt-sample Vault Access"
  }
}

