resource "aws_iam_user" "trainig_user" {
  name = "trainig.user@codefactorygroup.com"
  path = "/devops/"

  tags = local.tags
}

resource "aws_iam_access_key" "trainig_user" {
  user = aws_iam_user.trainig_user.name
}

resource "aws_iam_user_login_profile" "trainig_user" {
  user    = aws_iam_user.trainig_user.name
  pgp_key = "keybase:aprescornic"
}

