
output "iam_passwords" {
  value = {
    trainig_user = "-----BEGIN PGP MESSAGE-----\nComment: https://keybase.io/download\nVersion: Keybase Go 1.0.10 (linux)\n\n${aws_iam_user_login_profile.trainig_user.encrypted_password}\n-----END PGP MESSAGE-----\n",
  }
}

output "vpc_public_ips" {
  value = local.vpc_public_ips
}

output "docker_repositories" {
  value = tomap({ for repo in var.applications :
    repo => "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.name}.amazonaws.com/${repo}"
  })
}

output "jenkins_public_ip" {
  value = aws_instance.jenkins.public_ip
}