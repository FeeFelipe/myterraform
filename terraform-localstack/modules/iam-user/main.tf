# resource "aws_iam_user" "this" {
#   name = var.user_name
#   tags = var.tags
# }
#
# data "aws_iam_policy_document" "policy" {
#   statement {
#     effect = "Allow"
#     actions = ["s3:*", "sqs:*"]
#     resources = ["*"]
#   }
# }
#
# resource "aws_iam_user_policy" "policy" {
#   name   = "${var.user_name}-policy"
#   user   = aws_iam_user.this.name
#   policy = data.aws_iam_policy_document.policy.json
# }
