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

resource "aws_iam_user" "service_ecr_manage_manage" {
  name = "ci-ecr"
  path = "/"
}
resource "aws_iam_access_key" "service_ecr_manage_manage" {
  user = aws_iam_user.service_ecr_manage_manage.name
}

resource "aws_iam_policy" "service_ecr_manage_manage" {
  name = "ServiceECRManage"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "ListImagesInRepository",
        "Effect" : "Allow",
        "Action" : [
          "ecr:ListImages"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "GetAuthorizationToken",
        "Effect" : "Allow",
        "Action" : [
          "ecr:GetAuthorizationToken"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "ManageRepositoryContents",
        "Effect" : "Allow",
        "Action" : [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetRepositoryPolicy",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:DescribeImages",
          "ecr:BatchGetImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage",
          "eks:DescribeCluster"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "DescibeEKScluster",
        "Effect" : "Allow",
        "Action" : [
          "eks:DescribeCluster",
          "eks:ListClusters"
        ],
        "Resource" : "arn:aws:eks:eu-west-1:209591221760:cluster/*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "service_ecr_manage_manage" {
  user       = aws_iam_user.service_ecr_manage_manage.name
  policy_arn = aws_iam_policy.service_ecr_manage_manage.arn
}
