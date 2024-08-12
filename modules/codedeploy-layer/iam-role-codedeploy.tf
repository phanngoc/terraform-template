resource "aws_iam_role" "iac_standard_iam_role_codedeploy" {
  name               = "${var.project}-iam-role-codedeploy-${var.env}"
  assume_role_policy = data.template_file.iac_standard_assume_role_codedeploy.template
  description        = "${var.env}: codedeploy"

  tags = {
    Stage = "${var.env}"
  }
}

resource "aws_iam_role_policy_attachment" "iac_standard_policy_attachment_awscodedeployrole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = "${aws_iam_role.iac_standard_iam_role_codedeploy.name}"
}

data "aws_iam_policy_document" "code_deploy_policy" {
  # If the tasks in your Amazon ECS service using the blue/green deployment type require the use of
  # the task execution role or a task role override, then you must add the iam:PassRole permission
  # for each task execution role or task role override to the AWS CodeDeploy IAM role as an inline policy.
  statement {
    effect = "Allow"

    actions = [
      "iam:PassRole",
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "ecs:DescribeServices",
      "ecs:CreateTaskSet",
      "ecs:UpdateServicePrimaryTaskSet",
      "ecs:DeleteTaskSet",
      "cloudwatch:DescribeAlarms",
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "sns:Publish",
    ]

    resources = ["arn:aws:sns:*:*:CodeDeployTopic_*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:ModifyListener",
      "elasticloadbalancing:DescribeRules",
      "elasticloadbalancing:ModifyRule",
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "lambda:InvokeFunction",
    ]

    resources = ["arn:aws:lambda:*:*:function:CodeDeployHook_*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:GetObjectMetadata",
      "s3:GetObjectVersion",
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:ExistingObjectTag/UseWithCodeDeploy"
      values   = ["true"]
    }

    resources = ["*"]
  }
}

resource "aws_iam_policy" "code_deploy_policy" {
  name        = "code_deploy_policy"
  policy      = data.aws_iam_policy_document.code_deploy_policy.json
}

# https://www.terraform.io/docs/providers/aws/r/iam_role_policy_attachment.html
resource "aws_iam_role_policy_attachment" "default" {
  role       = "${aws_iam_role.iac_standard_iam_role_codedeploy.name}"
  policy_arn = aws_iam_policy.code_deploy_policy.arn
}