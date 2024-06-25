#here is the pot with shit
data "aws_iam_policy_document" "assume-role" {
  version = "2012-10-17"
  statement {
    sid    = ""
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["${var.service}.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "role" {
  name               = "ServiceRole-${var.name}"
  assume_role_policy = data.aws_iam_policy_document.assume-role.json
}

data "aws_iam_policy_document" "policy" {
  count   = var.action_list != null ? 1 : 0
  version = "2012-10-17"
  statement {
    sid       = ""
    effect    = "Allow"
    actions   = var.action_list
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "policy" {
  count  = var.action_list != null ? 1 : 0
  name   = "${var.name}"
  role   = aws_iam_role.role.id
  policy = data.aws_iam_policy_document.policy[0].json
}

resource "aws_iam_role_policy_attachment" "policy-attachment" {
  count      = var.policy != null ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/service-role/${var.policy}"
  role       = aws_iam_role.role.name
}

output "id" {
  value = aws_iam_role.role.id
}

output "arn" {
  value = aws_iam_role.role.arn
}

output "name" {
  value = aws_iam_role.role.name
}
