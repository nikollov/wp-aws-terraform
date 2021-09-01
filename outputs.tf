output "ami_id" {
  value = data.aws_ami.centos.id
}

output "Login" {
  value = "ssh centos@${aws_instance.ec2.public_ip}"
}

output "azs" {
  value = data.aws_availability_zones.azs.*.names
}

output "db_access_from_ec2" {
  value = "mysql -h ${aws_db_instance.mysql.address} -P ${aws_db_instance.mysql.port} -u ${var.db_user} -p ${var.db_pass}"
}

output "access" {
  value = "http://${aws_instance.ec2.public_ip}/index.php"
}
