output "jenkins_public_ip" {
  value = aws_instance.jenkins_server.public_ip
}

output "sonarqube_public_ip" {
  value = aws_instance.sonarqube_server.public_ip
}

output "vpc_id" {
  value = aws_vpc.main.id
}