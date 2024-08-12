resource "aws_codestarconnections_connection" "wnote-connect" {
  name          = "wnote-github-connect"
  provider_type = "GitHub"
}

resource "aws_codepipeline" "pipeline" {
  name     = "${var.project}-pipeline-${var.env}"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.artifact.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    # action {
    #   name             = "Source"
    #   category         = "Source"
    #   owner            = "ThirdParty"
    #   provider         = "GitHub"
    #   version          = "1"
    #   output_artifacts = ["source"]

    #   configuration = {
    #     Owner  = "${var.git_repository_owner}"
    #     Repo   = "${var.git_repository_name}"
    #     Branch = "${var.git_repository_branch}"
    #     OAuthToken = "${var.github_oauth_token}"
    #   }
    # }
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source"]
      run_order         = "1"

      configuration = {
        BranchName = "master"
        FullRepositoryId = "ngocp-0847/wnote"
        ConnectionArn = aws_codestarconnections_connection.wnote-connect.arn
        OutputArtifactFormat = "CODE_ZIP"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source"]
      output_artifacts = ["BuildOut"]

      configuration = {
        ProjectName = aws_codebuild_project.app_build.name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeployToECS"
      input_artifacts = ["BuildOut"]
      version         = "1"

      configuration = {
        # ClusterName = "${var.ecs_cluster_name}"
        # ServiceName = "${var.ecs_service_name}"
        # FileName    = "imageDetail.json"
        ApplicationName = var.codedeploy_application_name
        DeploymentGroupName = var.codedeploy_group_name
        TaskDefinitionTemplateArtifact = "BuildOut"
        TaskDefinitionTemplatePath = "taskdef.json"
        AppSpecTemplateArtifact = "BuildOut"
        AppSpecTemplatePath = "appspec.yml"
      }
    }
  }
}

resource "aws_iam_policy" "codepipeline_policy" {
  name        = "${var.project}_codepipeline_policy_${var.env}"
  policy      = "${data.aws_iam_policy_document.codepipeline_policy.json}"
  path        = "${var.iam_path}"
  description = "${var.description}"
}

data "aws_iam_policy_document" "codepipeline_policy" {
  statement {
    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.artifact.bucket}",
      "arn:aws:s3:::${aws_s3_bucket.artifact.bucket}/*",
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "codedeploy:CreateDeployment",
      "codedeploy:GetDeployment",
      "codedeploy:GetDeploymentConfig",
      "codedeploy:GetApplicationRevision",
      "codedeploy:RegisterApplicationRevision",
      "codedeploy:GetApplication",
    ]
  
    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "ecs:DescribeServices",
      "ecs:DescribeTaskDefinition",
      "ecs:DescribeTasks",
      "ecs:ListTasks",
      "ecs:RegisterTaskDefinition",
      "ecs:UpdateService",
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "iam:PassRole",
    ]

    resources = ["*"]
  }
}

# https://www.terraform.io/docs/providers/aws/r/iam_role_policy_attachment.html
resource "aws_iam_role_policy_attachment" "codepipeline_policy_attachment" {
  role       = "${aws_iam_role.codepipeline_role.name}"
  policy_arn = "${aws_iam_policy.codepipeline_policy.arn}"
}

resource "aws_iam_role" "codepipeline_role" {
  name               = "${var.project}_codepipeline_role_${var.env}"
  assume_role_policy = "${data.aws_iam_policy_document.pipeline_assume_role_policy.json}"
  path               = "${var.iam_path}"
  description        = "${var.description}"
  tags               = "${merge(tomap({Name = local.iam_name}), var.tags)}"
}

data "aws_iam_policy_document" "pipeline_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}