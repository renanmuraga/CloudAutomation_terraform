output "jenkins-app-name-output" {
  value       = "${lookup(aws_instance.jenkins.tags, "Name")}"
  description = "Jenkins"
}

output "allow-jenkins-output" {
  value       = "${lookup(aws_security_group.allow-jenkins.tags, "Name")}"
  description = "Security group Jenkins"
}
