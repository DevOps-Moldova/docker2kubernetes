# IAM Role to be granted ECR permissions
# data "aws_iam_role" "ecr" {
#   name = "ecr"
# }

module "ecr" {
  source  = "cloudposse/ecr/aws"
  version = "0.32.3"

  namespace = "cf"
  #   stage                  = "test"
  name = "trainig"
  #   principals_full_access = [data.aws_iam_role.ecr.arn]
  image_tag_mutability = "MUTABLE"
  scan_images_on_push  = false
  image_names          = ["frontend", "backend"]
}