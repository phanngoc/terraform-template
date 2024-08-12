resource "aws_iam_role" "lambda_cost_role" {
    name   = "Spacelift_Test_Lambda_Function_Role"
    assume_role_policy = <<EOF
    {
        "Version": "2012-10-17",
        "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
            "Service": "lambda.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
        ]
    }
    EOF
}

resource "aws_iam_policy" "lambda_cost_iam_policy" {
    name         = "aws_iam_policy_for_terraform_aws_lambda_role"
    path         = "/"
    description  = "AWS IAM Policy for managing aws lambda role"
    policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": [
       "logs:CreateLogGroup",
       "logs:CreateLogStream",
       "logs:PutLogEvents"
     ],
     "Resource": "arn:aws:logs:*:*:*",
     "Effect": "Allow"
   },
   {
      "Effect": "Allow",
      "Action": [
        "ec2:Start*",
        "ec2:Stop*"
      ],
      "Resource": "*"
   }
 ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
    role        = aws_iam_role.lambda_cost_role.name
    policy_arn  = aws_iam_policy.lambda_cost_iam_policy.arn
}

# data "archive_file" "zip_the_python_code" {
#     type        = "zip"
#     source_dir  = "${path.module}/python/"
#     output_path = "${path.module}/python/hello-python.zip"
# }

resource "aws_lambda_function" "terraform_lambda_func_start" {
    filename                       = "${path.module}/python/start.zip"
    function_name                  = "AutoTurnOnFunc"
    role                           = aws_iam_role.lambda_cost_role.arn
    handler                        = "start.lambda_handler"
    runtime                        = "python3.8"
    depends_on                     = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
}

resource "aws_cloudwatch_event_rule" "start_ec2" {
  name = "start-ec2"
  schedule_expression = "cron(0 8 * * ? *)"
  is_enabled = true
}

resource "aws_cloudwatch_event_rule" "stop_ec2" {
  name = "stop-ec2"
  schedule_expression = "cron(0 21 * * ? *)"
  is_enabled = true
}

resource "aws_cloudwatch_event_target" "start_ec2" {
    rule      = aws_cloudwatch_event_rule.start_ec2.name
    target_id = "start-ec2-target"

    arn = aws_lambda_function.terraform_lambda_func_start.arn
#     input_transformer {
#         input_paths = {
#             instance = "$.detail.instance",
#             status   = "$.detail.status",
#         }
#         input_template = <<EOF
# {
#   "action": "start"
# }
# EOF
#     }
    input = jsonencode({"action": "start"})
}

resource "aws_cloudwatch_event_target" "stop_ec2" {
  rule      = aws_cloudwatch_event_rule.stop_ec2.name
  target_id = "stop-ec2-target"

  arn = aws_lambda_function.terraform_lambda_func_start.arn

#   input_transformer {
#         input_paths = {
#             instance = "$.detail.instance",
#             status   = "$.detail.status",
#         }
#         input_template = <<EOF
# {
#   "action": "stop"
# }
# EOF
#     }

    input = jsonencode({"action": "stop"})
}


