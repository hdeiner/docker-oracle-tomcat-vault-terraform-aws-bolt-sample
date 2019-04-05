resource "aws_instance" "ec2_oracle" {
  count = 1
  ami = "ami-759bc50a"
  instance_type = "t2.medium"
  key_name = "${aws_key_pair.aws_key_pair.key_name}"
  security_groups = ["${aws_security_group.oracle.name}"]
  tags {
    Name = "docker-oracle-tomcat-vault-terraform-aws-bolt-sample Oracle ${format("%03d", count.index)}"
  }
}